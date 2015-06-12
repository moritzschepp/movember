app = angular.module "movember", []

app.run [ ->
  $("[role=popover]").popover()
]

app.service "eventually", [
  "$timeout",
  (timeout) ->
    promises = {}

    service = {
      delay: 300
      run: (name, fn, delay = service.delay) -> 
        timeout.cancel(promises[name]) if promises[name]
        promises[name] = timeout(fn, delay)
    }
]

app.controller "user_controller", [
  "$scope", "tools_service", "$location",
  (scope, t, location) ->
    window.s = scope
    window.t = t

    scope.user_path = ->
      location.absUrl().replace(t.base_url(), "")
    scope.load = ->
      t.http(url: scope.user_path()).success (data) -> 
        scope.user = data

    scope.available_goods = -> t.config.goods

    scope.can_buy = (key) ->
      money_left = Math.max(scope.user.amount_paid - scope.cart_value(), 0)
      money_left >= t.config.goods[key].price

    scope.cart_value = (add_one_of = null) ->
      total = 0
      for key, data of scope.user.cart
        total += data.amount * scope.available_goods()[key].price
      if add_one_of
        total += scope.available_goods()[add_one_of].price
      total

    scope.money_spent = ->
      if scope.user
        t.config.goods['vote'].price * scope.user.votes_spent
      else
        0

    scope.fill_up = (event, key) ->
      while scope.can_buy(key)
        scope.more(event, key)

      event.preventDefault() if event

    scope.empty = (event, key) ->
      good = scope.user.cart[key]
      if good
        good.amount = 0

      event.preventDefault() if event

    scope.more = (event, key) ->
      good = scope.user.cart[key]

      if good && good.amount
        if scope.cart_value(key) <= scope.user.amount_paid
          good.amount = parseInt(good.amount, 10) + 1
        else
          console.log "Too expensive"
      else
        if scope.cart_value(key) <= scope.user.amount_paid
          scope.user.cart[key] = {amount: 1}
        else
          console.log "I Too expensive"

      event.preventDefault() if event

    scope.less = (event, key) ->
      if scope.user.cart[key] && scope.user.cart[key].amount > 0
        scope.user.cart[key].amount -= 1

      event.preventDefault() if event

    scope.load()
]

app.service "tools_service", [
  "$http",
  (original_http) ->
    service = {
      config: {}
      load: ->
        service.http(url: "/info").success (data) -> 
          service.config = data
      base_url: -> 
        $('base').attr('href').replace(/\/$/, "")
      http: (request) ->
        request.headers ||= {}
        request.headers["accept"] ||= "application/json"
        request.method ||= "get"
        request.url = "#{service.base_url()}#{request.url}"
        original_http(request).success (data) -> console.log(data)
    }
    service.load()
    service
]

app.controller "users_controller", [
  "$scope", "eventually", "tools_service",
  (scope, eventually, t) ->
    scope.config = -> t.config
    scope.search_terms = ""

    scope.$watch "search_terms", -> 
      eventually.run "user_search", scope.search

    scope.search_terms_to_email = ->
      if scope.search_terms.match(/@/)
        scope.search_terms
      else
        if t.config && t.config.mail
          default_domain = t.config.mail.default_domain
          "#{scope.search_terms}@#{default_domain}"
    
    scope.search = ->
      request = {
        url: "/users"
        params: {terms: scope.search_terms}
      }

      t.http(request).success (data) -> scope.data = data
    scope.users = -> scope.data

]

app.controller "voting_controller", [
  "$scope", "tools_service",
  (scope, ts) ->
    ts.http(url: "/features.json").success (data) -> scope.features = data
    ts.http(url: "/people.json").success (data) -> scope.people = data
    ts.http(url: "/votes/personal.json").success (data) -> scope.personal_votes = data
    ts.http(url: "/me.json").success (data) -> scope.user = data

    scope.votes_for = (feature, person) ->
      key = feature.id + '-' + person.id
      i = if scope.votes then scope.votes.index else {}
      i[key]

    scope.personal_votes_for = (feature, person) ->
      key = '[' + feature.id + ', ' + person.id + ']'
      i = scope.personal_votes || {}
      i[key]

    scope.listing = ->
      unless scope.listing_data
        person_index = {}
        feature_index = {}

        for p in scope.people
          person_index[p.id] = p
        for f in scope.features
          feature_index[f.id] = f

        scope.listing_data = for i in scope.votes.items
          result = {
            person: person_index[item.person_id]
            feature: feature_index[item.feature_index]
            count: item.count
          }


      scope.listing_data

    scope.vote = (feature, person) ->
      unless scope.voting
        scope.voting = true

        ts.http(
          url: "/votes.json", 
          method: "post", 
          data: {feature_id: feature.id, person_id: person.id}
        ).success( (data) ->
          ts.http(url: "/me.json").success (data) -> 
            scope.user = data
            scope.voting = false
          ts.http(url: "/votes/personal.json").success (data) -> scope.personal_votes = data
        )

    window.s = scope
]

app.filter "vote_count", [ ->
  (input) ->
    switch input
      when 0, null, undefined then "0 votes"
      when 1 then "1 vote"
      else
        "#{input} votes"
]

app.filter "yesno", [->
  (input) -> 
    if !!input then "yes" else "no"
]

this.app = app