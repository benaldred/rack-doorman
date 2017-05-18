# Rack::Doorman
*Rack middleware for limiting access to non Co-op people*

Rack::Doorman is a rack middleware to protect your web app from bad clients.
It allows *safelisting* of Co-op IP addresses and the option to allow non Co-op IP ranges to sign in with basic auth.

## Getting started

Add it to your Gemfile with bundler:

```ruby
# In your Gemfile
gem 'rack-doorman', :git => 'https://github.com/coopdigital/rack-doorman'
```

Then in your Rackup files:

```ruby
# In config.ru
use Rack::Doorman, '/' => ['51.179.186.108']
```

## How it works

*explain the use of Rack::Attack*

## Usage

*explain how it works*

## Use cases

*explain use cases*

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
