# GenronSF

Utility for [超・SF作家育成サイト](https://school.genron.co.jp/works/sf/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'genron_sf'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install genron_sf

## Usage

### Scraper

```ruby
GenronSF::Subject.list(year: 2018) # 課題一覧
GenronSF::Subject.get(year: 2018, number: 1) # 課題詳細

GenronSF::Student.list(year: 2018) # 受講生一覧
GenronSF::Student.get(year: 2018, id: 'fujinakahara') # 受講生詳細

GenronSF::Work.get(year: 2018, student_id: 'fujinakahara', id: 2788) # 作品詳細

GenronSF::ScoreTable.get(year: 2018) # 得点一覧表
```

### EBook Generator

    $ genron_sf_ebook --type student --year 2018 --id fujinakahara --output ./genron_sf-2018-fujinakahara.epub

Run `genron_sf_ebook --help` for more detail.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
