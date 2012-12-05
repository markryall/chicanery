require 'fileutils'

module Chicanery
  module Git
    class Repo
      include FileUtils

      attr_reader :name, :path, :branches, :remotes

      def initialize name, path, params={}
        @name, @path = name, path
        @branches = params[:branches] || []
        @remotes = params[:remotes] || {}
      end

      def in_repo
        Dir.chdir(path) { yield }
      end

      def prepare
        return if File.exists? path
        mkdir_p path
        in_repo { git 'init' }
      end

      def state
        prepare
        response = {}
        in_repo do
          remotes.each do |name, remote|
            remotes_status[name] = {}
            git "remote add #{name} #{remote[:url]}" unless git("remote | grep #{name}") == name
            git "fetch -q #{name}"
            (remote[:branches] || ['master']).each do |branch|
              response["#{name}/#{branch}"] = head "#{name}/#{branch}"
            end
          end
          branches.each do |branch|
            response[branch] = head branch
          end
        end
        response
      end

      def head branch
        /^([^ ]*) /.match git "log -n 1 #{branch} --pretty=oneline"
        match[1] if match
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
