require 'net/http'
require "ipaddr"

module Rack

  ##
  # Rack middleware for limiting access based on IP address
  #
  #
  # === Options:
  #
  #   path => ipmasks      ipmasks: Array of remote addresses which are allowed to access
  #
  # === Examples:
  #
  #  use Rack::Doorman, '/' => [ '127.0.0.1',  '192.168.1.0/24' ]
  #
  # TODO subclass from Rack::Access

  class Doorman
    attr_reader :options

    def initialize(app, options = {})
      @app = app
      mapping = options.empty? ? {"/" => ["127.0.0.1"]} : options
      @mapping = remap(mapping)
    end

    def remap(mapping)
      mapping.map { |location, ipmasks|
        if location =~ %r{\Ahttps?://(.*?)(/.*)}
          host, location = $1, $2
        else
          host = nil
        end

        unless location[0] == ?/
          raise ArgumentError, "paths need to start with /"
        end
        location = location.chomp('/')
        match = Regexp.new("^#{Regexp.quote(location).gsub('/', '/+')}(.*)", nil, 'n')

        ipmasks.collect! do |ipmask|
          ipmask.is_a?(IPAddr) ? ipmask : IPAddr.new(ipmask)
        end
        [host, location, match, ipmasks]
      }.sort_by { |(h, l, m, a)| [h ? -h.size : (-1.0 / 0.0), -l.size] }  # Longest path first
    end

    def call(env)
      @original_request = Request.new(env)
      ipmasks = ipmasks_for_path(env)

      status, headers, body = @app.call(env)



      if (ENV['USERNAME'] && ENV['PASSWORD']) || ENV['CREDENTIALS'] # we want to auth as fallback
        if ip_authorized?(ipmasks)
          [status, headers, body]
        elsif authorized?(env)
          @app.call(env)
        else
          authenticate!
        end
      else
        return forbidden! unless ip_authorized?(ipmasks)
        [status, headers, body]
      end
    end

    def ipmasks_for_path(env)
      path = env["PATH_INFO"].to_s
      hHost, sName, sPort = env.values_at('HTTP_HOST','SERVER_NAME','SERVER_PORT')
      @mapping.each do |host, location, match, ipmasks|
        next unless (hHost == host || sName == host \
            || (host.nil? && (hHost == sName || hHost == sName+':'+sPort)))
        next unless path =~ match && rest = $1
        next unless rest.empty? || rest[0] == ?/

        return ipmasks
      end
      nil
    end

    def forbidden!
      [403, { 'Content-Type' => 'text/html', 'Content-Length' => '0' }, []]
    end

    def authenticate!
      [401, {'WWW-Authenticate' => 'Basic realm="Application"', "Content-Type" => "text/html"}, ["Not Authorized on this environment."]]
    end

    def ip_authorized?(ipmasks)
      return true if ipmasks.nil?

      ipmasks.any? do |ip_mask|
        ip_mask.include?(IPAddr.new(@original_request.ip))
      end
    end

    def authorized?(env)
      auth = Rack::Auth::Basic::Request.new(env)
      return false unless auth.provided? && auth.basic? && auth.credentials
      if ENV['USERNAME']
        auth.credentials == [ENV['USERNAME'], ENV['PASSWORD']]
      elsif ENV['CREDENTIALS']
        credentials = ENV['CREDENTIALS'].split(",").map {|c| c.split(':')}
        credentials.include?(auth.credentials)
      else
        false
      end
    end
  end
end
