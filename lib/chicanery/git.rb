require 'fileutils'

module Chicanery
  module Git
    class Repo
      attr_reader :name, :url

      def initialize params
        @name, @remotes = params[:name], params[:remotes]
        @remotes['origin'] = { url: params[:url], branches: params[:branches] }
      end

      def state
        FileUtils.mkdir 'repos' unless File.exists? 'repos'

        Dir.chdir('repos') do
          `git clone -q -n #{@url} #{name}` unless File.exists? name
        end

        remotes = {}
        Dir.chdir("repos/#{name}") do
          @remotes.each do |name, remote|
            remotes[name] = {}
            `git remote add #{name} #{remote[:url]}` unless `git remote | grep #{name}`.chomp == name
            `git fetch -q #{name}`
            (remote[:branches] || ['master']).each do |branch|
              `git log -n 1 #{name}/#{branch} --oneline` =~ /^([^ ]*) /
              remotes[name][branch] = $1
            end
         end
        end
        remotes
      end
    end

    def git_repo params
      repo Repo.new params
    end
  end
end