# Rack::Doorman
*Rack middleware for limiting access to non Co-op people*

Rack::Doorman is a rack middleware to protect your web app from bad clients.
It allows *safelisting* of IP addresses and the option to allow non safelisted ranges to sign in with basic auth.

## Getting started

### Using straight from Github

Add it to your Gemfile with bundler:

```ruby
# In your Gemfile
gem 'rack-doorman', git: 'git@github.com:benaldred/rack-doorman.git'
```

Then in your Rackup files:

```ruby
# In config.ru
require 'bundler/setup' # we need this to load the gem from bundler properly
require 'rack/doorman'
use Rack::Doorman, '/' => ['127.0.0.1',  '192.168.1.0/24']
```

## With Rails 6

```ruby
# In config.initilizers/rack_doorman.rb
Rails.application.config.middleware.use Rack::Doorman, '/' => ['127.0.0.1',  '192.168.1.0/24']

```

## Enabling the basic auth for non whitelisted IP ranges

Setup the `ENV['USERNAME']` and `ENV['PASSWORD']`. With both these exported Doorman will activate basic auth on non-safelisted IP ranges

### Testing pull requests

To run the minitest test suite, you will need to:

Install dependencies by running
```sh
bundle install
```

Then run the test suite by running
```sh
bundle exec rake
```

Or run it automagically with guard
```sh
bundle exec guard
```

# Why Rack::Doorman

1. We have a quite a few Jekyll sites that are basic auth password protected. Safelisting IP ranges to allow people to view them seemed useful
2. We need to be able to open up our (food) prototype to specific IP ranges of stores without a password

# How does it work

Jekyll is built on top of rack so this is a rack middleware that is inserted before the site is served to do some checks.

It's actually a copy of `Rack::Access` with the addition of the option to fall back to basic auth.

The gem is also based on a pettern that was used on the [Wills](https://gitlab.digitalplatform.coop.co.uk/Wills/wills) Project
