require 'net/http'
require 'nokogiri'
require 'date'

module Chicanery
  class Cctray
    attr_reader :uri, :user, :password

    def initialize url, user, password
      @uri, @user, @password = URI(url), user, password
    end

    def get
      req = Net::HTTP::Get.new(uri.path)
      req.basic_auth user, password
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |https|
        https.request(req)
      end
      res.body
    end

    def jobs
      Nokogiri::XML(get).css("Project").map do |project|
        {
          name: project[:name],
          activity: project[:activity],
          last_build_status: project[:lastBuildStatus],
          last_build_time: DateTime.parse(project[:lastBuildTime]),
          url: project[:webUrl],
          last_label: project[:lastBuildLabel]
        }
      end
    end
  end
end