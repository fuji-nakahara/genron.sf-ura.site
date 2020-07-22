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

### 課題一覧の取得

```ruby
GenronSF::Subject.list(year: 2018)
```

### 課題詳細の取得

```ruby
GenronSF::Subject.get(year: 2018, number: 1)
```

### 受講生一覧の取得

```ruby
GenronSF::Student.list(year: 2018)
```

### 受講生詳細の取得

```ruby
GenronSF::Student.get(year: 2018, id: 'fujinakahara')
```

### 作品の取得

```ruby
GenronSF::Work.get(year: 2018, student_id: 'fujinakahara', id: 2788)
```

### 電子書籍の作成

    $ genron_sf_ebook --type student --year 2018 --id fujinakahara --output ./genron_sf-fujinakahara-2018.epub

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
