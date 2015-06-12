class MoVember
  constructor: ->
    @root_url = $('body').attr 'data-root-url'
  
    this.people().on 'click', '.glower', (event) =>
      this.people().find('.glower').removeClass 'current'
      $(event.currentTarget).addClass 'current'
      
    this.features().on 'click', '.glower', (event) =>
      this.features().find('.glower').removeClass 'current'
      $(event.currentTarget).addClass 'current'
      
    $("form.vote").on 'submit', (event) =>
      try
        person_id = this.people().find('.glower.current').parents('.person').attr('data-id')
        feature_id = this.features().find('.glower.current').parents('.feature').attr('data-id')
        $('input[name=feature_id]').val feature_id
        $('input[name=person_id]').val person_id
      catch e
        alert "Please select a person as well as a feature"

      return false unless person_id && feature_id
      
      if this.mobile()
        $('form').submit()
      else
        $.ajax(
          url: "vote",
          type: "POST"
          data: {'person_id': person_id, 'feature_id': feature_id}
          success: => $('.thanks').modal()
        )
      
      false
      
    $('.thanks').on 'click', '.back-to-root', (event) =>
      window.location.href = @root_url
      
  people: => $('.people')
  features: => $('.features')
  
  rotate_people: =>
    if @people_index >= @data.people.length
      @people_index = 0
      
    dataset = @data.people[@people_index]
    this.person().find('h3').html dataset.name
    this.person().find('img').attr 'src', dataset.url
    
    @people_index += 1
  
    
  rotate_features: =>  
    if @features_index >= @data.features.length
      @features_index = 0
      
    dataset = @data.features[@features_index]
    this.feature().find('h3').html dataset.name
    this.feature().find('img').attr 'src', dataset.url
    
    @features_index += 1
    
    android: => navigator.userAgent.match(/Android/i)
    blackberry: => navigator.userAgent.match(/BlackBerry/i)
    windows: => navigator.userAgent.match(/IEMobile/i)
    opera: => navigator.userAgent.match(/Opera Mini/i)
    ios: => navigator.userAgent.match(/iPhone|iPad|iPod/i)
    
    mobile => this.android() || this.ios() || this.windows() || this.opera() || this.blackberry()
    
$ ->
  window.mo_vember = new MoVember()
