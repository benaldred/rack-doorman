require "rubygems"
require "bundler/setup"

require "minitest/autorun"
require "minitest/pride"
require "rack/test"


require "rack/doorman"

class MiniTest::Spec

  include Rack::Test::Methods

  def app
    Rack::Builder.new {
      use Rack::Doorman, '/' => ['1.2.3.4']
      run lambda {|env| [200, {}, ['Hello World']]}
    }.to_app
  end
end

class Minitest::SharedExamples < Module
  include Minitest::Spec::DSL
end
