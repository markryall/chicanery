require 'net/http'
require 'nokogiri'
require 'date'

module Chicanery
  class Cctray
    attr_reader :name, :uri, :user, :password

    def initialize name, url, user=nil, password=nil
      @name, @uri, @user, @password = name, URI(url), user, password
    end

    def get
      req = Net::HTTP::Get.new(uri.path)
      req.basic_auth user, password if user and password
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |https|
        https.request(req)
      end
      res.body
    end

    def jobs
      jobs = {}
      Nokogiri::XML(get).css("Project").each do |project|
        jobs[project[:name]]= {
          activity: project[:activity],
          last_build_status: project[:lastBuildStatus] == 'Success' ? :success : :failure,
          last_build_time: DateTime.parse(project[:lastBuildTime]),
          url: project[:webUrl],
          last_label: project[:lastBuildLabel]
        }
      end
      jobs
    end
  end
end