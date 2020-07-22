# genron-sf-fun

https://genron-sf-fun.herokuapp.com/

## Ruby version

See [.ruby-version](.ruby-version)

## System dependencies

- PostgreSQL 9.2 and later

## Setup development environment

    $ bin/setup

## Database creation & initialization

    $ bin/rake db:create
    $ bin/rake ridgepole:apply

## How to run the test suite

    $ bin/rake spec

## Deployment

Every push to `master` will start CI, and after it passes deployment on Heroku happens automatically. 

## Heroku add-ons

- Heroku Postgres
- Heroku Scheduler
- MemCachier
- Sentry
