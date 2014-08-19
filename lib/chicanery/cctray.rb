require 'chicanery/site'
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

    class Server < Chicanery::Site
      def jobs
        jobs = {}
        response_body = get
        File.open("#{Time.now.to_i}.xml", 'w') {|f| f.puts response_body} if ENV['CHICANERY_CAPTURE']
        Nokogiri::XML(response_body).css("Project").each do |project|
          job = {
            activity: project[:activity] == 'Sleeping' ? :sleeping : :building,
            last_build_status: parse_build_status(project[:lastBuildStatus]),
            last_build_time: parse_build_time(project[:lastBuildTime]),
            url: project[:webUrl],
            last_label: project[:lastBuildLabel]
          }
          project.css('message').each do |message|
            job[:breaker] = message[:text] if message[:kind] == 'Breakers'
          end
          jobs[project[:name]] = job unless filtered project[:name]
        end
        raise "could not find any jobs in response: [#{response_body}]" if jobs.empty?
        jobs
      end

      def parse_build_time time
        return nil if time.nil? || time.empty? || time == '0'
        DateTime.parse(time).to_time.to_i
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
