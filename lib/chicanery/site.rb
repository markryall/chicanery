require 'net/http'

module Chicanery
  class Site
    attr_reader :name, :uri, :options, :body, :code

    def initialize name, url, options={}
      @name, @uri, @options = name, URI(url), options
    end

    def get
      req = Net::HTTP::Get.new uri.path
      req.basic_auth options[:user], options[:password] if options[:user] and options[:password]
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |https|
        https.request req
      end
      @code, @body = res.code, res.body
      res.value #check for success via a spectactulalry poorly named method
      res.body
    end
  end
end