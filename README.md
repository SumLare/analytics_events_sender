# AnalyticsEventsSender

[![Build Status](https://travis-ci.org/SumLare/analytics_events_sender.svg?branch=master)](https://travis-ci.org/SumLare/analytics_events_sender)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'analytics_events_sender'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install analytics_events_sender

## Usage

First of all, you have to configure analytics events sender, by defining platforms api keys and ids in, for example, `config/initializers/analytics_events_sender.rb`:

```ruby
AnalyticsEventsSender.configuration do |config|
  config.mixpanel = { token: ENV['YOUR_TOKEN'] }
  config.appmetrica = { app_id: ENV['YOUR_APP_ID'], api_key: ENV['YOUR_KEY'] }
  config.amplitude = { api_key: ENV['YOUR_KEY'] }
  config.appsflyer = { app_id: ENV['YOUR_APP_ID'], api_key: ENV['YOUR_KEY'] }
end
```

Call dispatcher from your controller and pass which platforms you want to use:

```ruby
AnalyticsEventsSender::Dispatcher.call(user, params, %w[mixpanel appmetrica amplitude])
```

After this it will make requests to platforms you've chosen and return `true` if they were successful.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/analytics_events_sender. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AnalyticsEventsSender project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/analytics_events_sender/blob/master/CODE_OF_CONDUCT.md).
