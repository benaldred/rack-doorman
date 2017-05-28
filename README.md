# Rack::Doorman
*Rack middleware for limiting access to non Co-op people*

Rack::Doorman is a rack middleware to protect your web app from bad clients.
It allows *safelisting* of Co-op IP addresses and the option to allow non safelisted ranges to sign in with basic auth.

## Getting started

### Using straight from Github

Add it to your Gemfile with bundler:

```ruby
# In your Gemfile
gem 'rack-doorman', git: 'git@github.com:coopdigital/rack-doorman.git'
```

Then in your Rackup files:

```ruby
# In config.ru
require 'bundler/setup' # we need this to load the gem from bundler properly
require 'rack/doorman'
use Rack::Doorman, '/' => ['127.0.0.1',  '192.168.1.0/24']
```

### With heroku

Because `rack-doorman` is a private Gem at the moment to be able to use it on Heroku we need to vendor the gem and use it locally.

Ruby Gem does not support installing gems via git so we need to build the gem locally, install it then unpack it to vendor.

1. In the root of this project `gem build rack-doorman.gemspec`
2. Install the gem from the local file `gem install --local rack-doorman-<VERSION>.gem`
3. In the project you wish to use the gem `gem unpack rack-doorman --target vendor/gems # or other path`
4. The `config.ru` stays the sample
5. In the `Gemfile`
```
gem 'rack-doorman', path: 'vendor/gems/rack-doorman-<VERSION>' # or path unpacked into
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
