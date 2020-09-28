# genron-sf-fun

A Ruby on Rails application for [ゲンロン 大森望 SF創作講座](https://school.genron.co.jp/sf/) community.  
https://genron-sf-fun.herokuapp.com/

## System dependencies

- Ruby
- PostgreSQL

## Setup development environment

    $ bin/setup

## Run the test suite

    $ bin/rake spec

## Fetch and save the data from [超・SF作家育成サイト](https://school.genron.co.jp/works/sf/)

    $ bin/rake db:seed

To load only the latest data:

    $ bin/rails runner 'ImportLatestJob.perform_now'

## Make the first user be admin

    $ bin/rails runner 'User.first.toggle!(:admin)'

## Enable Twitter integration

Update `TWITTER_*` values in `.env` with your Twitter app credentials.

## Update database schema

    $ bin/rake ridgepole:apply

## Deployment

Every push to `master` will start CI, and after it passes, deployment to Heroku will happen automatically. 

## Heroku add-ons

- Heroku Postgres
- Heroku Scheduler
- MemCachier
- Sentry
