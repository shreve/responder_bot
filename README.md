# ResponderBot

A simple framework for defining a text-based interface

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'responder_bot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install responder_bot

## Usage

Check out the examples directory for detailed usage examples. This gem is a bit
complicated to put the usage inline here.

Here's a simple example to illustrate the idea at it's core.

```ruby
class SimpleResponder < ResponderBot::Handler
  handle_response do |reply|
    reply.quit { "Ok, thanks for playing!" }
    reply.likert { "I'm glad you feel that way." }
    reply.yes { "Awesome, thanks." }
  end
end

SimpleResponder.new("1").handle_response!
# => "I'm glad you feel that way."

SimpleResponder.new("Yes!").handle_response!
# => "Awesome, thanks."
```

This example is super trivial, but don't worry, it gets better.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/shreve/responder_bot.

I am particularly looking for feedback on

1. Default matchers (`ResponderBot.default_matchers`)
2. New types of matchers

## License

The gem is available as open source under the terms of
the [MIT License](https://opensource.org/licenses/MIT).
