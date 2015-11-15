# RecurlyEvent
[![Build Status](https://travis-ci.org/ejaypcanaria/recurly_event.svg)](https://travis-ci.org/ejaypcanaria/recurly_event) [![Code Climate](https://codeclimate.com/github/ejaypcanaria/recurly_event/badges/gpa.svg)](https://codeclimate.com/github/ejaypcanaria/recurly_event) [![Test Coverage](https://codeclimate.com/github/ejaypcanaria/recurly_event/badges/coverage.svg)](https://codeclimate.com/github/ejaypcanaria/recurly_event/coverage) [![Gem Version](https://badge.fury.io/rb/recurly_event.svg)](https://badge.fury.io/rb/recurly_event)

RecurlyEvent is a simple Ruby DSL for managing [Recurly Webhooks](https://recurly.readme.io/v2.0/page/webhooks) inside a Rails application. This project is inspired by the [StripeEvent](https://github.com/integrallis/stripe_event/) gem and is built using pub/sub API of [ActiveSupport::Notifications](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recurly_event'
```

And then execute:

    $ bundle

Mount the Rails Engine to your route:
```ruby
# config/routes.rb
mount RecurlyEvent::Engine, at: "/your-chosen-path"
```

## Usage
Add an initializer to your Rails application:
```ruby
# config/initializers/recurly.rb
RecurlyEvent.configure do |events|
  # To subscribe to a webhook, just pass in the event name and
  # an instance of a class that responds to `call(recurly_object)`
  events.subscribe "account.new", AccountCreated.new

  # You can also subscribe to a namespace of events.
  # In this case, you will be notified of all the invoice actions webhook
  events.subscribe "invoice.", InvoiceEventHandler.new

  # Subscribe to all the events
  events.all RecurlyEventLogger.new
end
```

### Event name convention
All Recurly webhooks are listed [here](https://recurly.readme.io/v2.0/page/webhooks). Here's a sample `new_account_notification` XML response from their website:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<new_account_notification>
  <account>
    <account_code>1</account_code>
    <username nil="true"></username>
    <email>verena@example.com</email>
    <first_name>Verena</first_name>
    <last_name>Example</last_name>
    <company_name nil="true"></company_name>
  </account>
</new_account_notification>
```
As you can see above the top level node is the event name from Recurly, in this case `new_account_notification`. The convention in this gem follows this pattern for the event name: `[noun].[verb]`. So, if you want to subscribe to this event, the event name is `account.new`.

### Callable object
The second parameter in the `subscribe` method is an instance of a class that responds to `call(recurly_object)`. This will be triggered once Recurly fires the webhook.

```ruby
# Plain old Ruby object
class AccountCreated
  def call(recurly_object)
    # recurly_object is an OpenStruct that has the same structure as the XML without the parent node (the event name).
    # You can get specific attributes by traversing the object like this:
    puts recurly_object.account.username
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ejaypcanaria/recurly_event. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](CODE_OF_CONDUCT.md) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
