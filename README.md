MoVember
========

This is a rails application to do a [movember](http://en.wikipedia.org/wiki/Movember) event

Currently it features

* a mobile friendly web frontend (based on twitter bootstrap)
* mobile-enabled selling of votes
* selling of additional goods (mugs, t-shirts, etc.)
* uploading preview images for people and mustaches to vote for
* bulk import of known email addresses

Setup
-----

Make sure ruby is installed (>= 2.0.0). If you are using rbenv, the app will
require 2.1.6. Then install the bundler gem:

```bash
gem install bundler
```

Clone the movember repository to a path of your choice and make the directory
your working directory.


```bash
git clone https://github.com/moritzschepp/movember.git movember
cd movember
```

Install the dependencies for the app

```bash
bundle install
```

Setup the (sqlite3) database and insert initial data. This includes a set of 
default mustaches which you are free to extend or delete.

```bash
bundle exec rake db:setup
```

Make copies of the default config files and make appropriate changes:

```bash
cp config/app.defaults.yml config/app.yml
cp config/frontpage.html.erb.example config/frontpage.html.erb
```

Generate a cookie signature secret and insert it into
config/initializers/secret_token.rb

```bash
bundle exec rake secret
```

Now you can start the app

```bash
bundle exec rails server
```

... and navigate to http://localhost:3000, the default admin credentials are
"admin@example.com" with password "secret"