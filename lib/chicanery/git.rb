require 'fileutils'

module Chicanery
  module Git
    class Repo
      attr_reader :name, :url, :remotes

      def initialize name, url, params
        @name, @remotes = name, params[:remotes]
        @remotes ||= {}
        @remotes['origin'] = { url: url, branches: params[:branches] }
      end

      def state
        FileUtils.mkdir 'repos' unless File.exists? 'repos'

        Dir.chdir('repos') do
          git "clone -q -n #{remotes['origin'][:url]} #{name}" unless File.exists? name
        end

        remotes_status = {}
        Dir.chdir("repos/#{name}") do
          remotes.each do |name, remote|
            remotes_status[name] = {}
            git "remote add #{name} #{remote[:url]}" unless git("remote | grep #{name}") == name
            git "fetch -q #{name}"
            (remote[:branches] || ['master']).each do |branch|
              git("log -n 1 #{name}/#{branch} --oneline") =~ /^([^ ]*) /
              remotes_status[name][branch] = $1
            end
         end
        end
        remotes_status
      end

      def git command
        `git #{command}`.chomp
      end
    end

    def git_repo *args
      repo Repo.new *args
    end
  end
end
