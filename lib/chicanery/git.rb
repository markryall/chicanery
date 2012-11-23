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
        `git clone -q #{@url} #{name}` unless File.exists? name
      end

      Dir.chdir("repos/#{name}") do
        `git pull -q`
        `git log -n 1 --oneline` =~ /^([^ ]*) /
        $1
      end
    end
  end
end