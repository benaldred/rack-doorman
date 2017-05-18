require_relative 'spec_helper'

describe 'Rack::Doorman' do

  before do
    ENV['USERNAME'] = nil
  end

  # blocks non coop ip addresses
  it 'blocks non approved ip address' do
    get '/'
    last_response.status.must_equal 403
  end

  it "allows approved ip addresses" do
    get '/', {}, 'REMOTE_ADDR' =>  '1.2.3.4'
    last_response.status.must_equal 200
  end


  describe 'basic auth enabled' do

    before do
      ENV['USERNAME'] = 'coop'
      ENV['PASSWORD'] = 'notforsharing'
    end

    it "allows approved ip addresses" do
      get '/', {}, 'REMOTE_ADDR' =>  '1.2.3.4'
      last_response.status.must_equal 200
    end

    it 'prompts for basic auth' do
      get '/'
      last_response.status.must_equal 401
    end

    it 'prompts for basic auth on bad login' do
      authorize 'coop', 'foooo'
      get '/'
      last_response.status.must_equal 401
    end

    it 'allows login using username and password' do
      authorize 'coop', 'notforsharing'
      get '/'
      last_response.status.must_equal 200
    end
  end
end
