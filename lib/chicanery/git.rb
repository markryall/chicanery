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
            (remote[:branches] || ['master']).each do |branch|
              response["#{name}/#{branch}"] = remote_head remote[:url], branch
            end
          end
          branches.each { |branch| response[branch] = head branch }
        end
        response
      end

      def remote_head url, branch
        sha "ls-remote #{url} #{branch}"
      end

      def head branch
        sha "log -n 1 #{branch} --pretty=oneline"
      end

      def sha command
        git(command).split.first
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
