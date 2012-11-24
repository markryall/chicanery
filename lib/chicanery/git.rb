require 'fileutils'

module Chicanery
  class Git
    attr_reader :name, :url

    def initialize name, url
      @name, @url = name, url
    end

    def state
      FileUtils.mkdir 'repos' unless File.exists? 'repos'

      Dir.chdir('repos') do
        `git clone -q -n #{@url} #{name}` unless File.exists? name
      end

      Dir.chdir("repos/#{name}") do
        `git fetch -q origin`
        `git log -n 1 origin/master --oneline` =~ /^([^ ]*) /
        $1
      end
    end
  end
end