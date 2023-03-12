# genron.sf-ura.site

A Ruby on Rails application for [ゲンロン 大森望 SF創作講座](https://school.genron.co.jp/sf/) community.  
https://genron.sf-ura.site/

## System dependencies

- Ruby
- PostgreSQL

## Development environment

Using [Dev Container](https://code.visualstudio.com/docs/devcontainers/containers.)

## Run the test suite

    $ bin/rake spec

## Fetch and save the data from [超・SF作家育成サイト](https://school.genron.co.jp/works/sf/)

    $ bin/rake db:seed

## Make the first user be admin

    $ bin/rails runner 'User.first.toggle!(:admin)'

## Enable Twitter integration

Update `TWITTER_*` values in `.env` with your Twitter app credentials.

## Update database schema

    $ bin/rake ridgepole:apply

## Deployment

Every push to `main` will start CI, and after it passes, deployment to Heroku will happen automatically. 

## Heroku add-ons

- Heroku Postgres
- Heroku Scheduler
- MemCachier
- Sentry
