require 'net/http'
require 'nokogiri'
require 'date'

module Chicanery
  module Cctray
    def self.new *args
      Cctray::Server.new *args
    end

    def cctray *args
      server Cctray::Server.new *args
    end

    class Server
      attr_reader :name, :uri, :options

      def initialize name, url, options={}
        @name, @uri, @options = name, URI(url), options
      end

      def get
        req = Net::HTTP::Get.new(uri.path)
        req.basic_auth options[:user], options[:password] if options[:user] and options[:password]
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |https|
          https.request(req)
        end
        res.value #check for success via a spectactulalry poorly named method
        res.body
      end

      def jobs
        jobs = {}
        response_body = get
        Nokogiri::XML(response_body).css("Project").each do |project|
          job = {
            activity: project[:activity] == 'Sleeping' ? :sleeping : :building,
            last_build_status: parse_build_status(project[:lastBuildStatus]),
            last_build_time: project[:lastBuildTime].empty? ? nil : DateTime.parse(project[:lastBuildTime]).to_time.to_i,
            url: project[:webUrl],
            last_label: project[:lastBuildLabel]
          }
          jobs[project[:name]] = job unless filtered project[:name]
        end
        raise "could not find any jobs in response: [#{response_body}]" if jobs.empty?
        jobs
      end

      def parse_build_status status
        case status
        when /^Success/ then :success
        when /^Unknown/ then :unknown
        else :failure
        end
      end

      def filtered name
        return false unless options[:include]
        !options[:include].match(name)
      end
    end
  end
end
