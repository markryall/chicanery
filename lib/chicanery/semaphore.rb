require 'chicanery/site'
require 'date'
require 'json'

module Chicanery
  module Semaphore
    def self.new *args
      Semaphore::Server.new *args
    end

    def semaphore *args
      server Semaphore::Server.new *args
    end

    class Server < Chicanery::Site
      def jobs
        jobs = {}

        response = JSON.parse(get)
        project_name = response['project_name']
        branch = response['branch_name']
        name = "#{project_name} #{branch}"

        sorted_builds = response['builds'].sort_by do |build|
          build['build_number']
        end.reverse

        completed = %w[passed failed].include?(sorted_builds.first["result"])

        most_recent_completed_build = sorted_builds.find do |build|
          %w[passed failed].include?(build["result"])
        end

        build_number = most_recent_completed_build["build_number"]
        build_url = most_recent_completed_build["build_url"]
        result = most_recent_completed_build['result']
        commit_url = most_recent_completed_build['commit']['url']
        committer = most_recent_completed_build['commit']['author_name']
        time = most_recent_completed_build["finished_at"]

        jobs[name] = {
          activity: completed ? :sleeping : :building,
          last_build_status: parse_build_status(result),
          last_build_time: parse_build_time(time),
          url: build_url,
          last_label: build_number,
          commit_url: commit_url,
          committer: committer
        }

        jobs
      end

      def parse_build_time time
        return 0 if time.nil? || time.empty? || time == '0'

        DateTime.parse(time).to_time.to_i
      end

      def parse_build_status status
        case status
        when /^passed/ then :success
        when /^failed/ then :failure
        else :unknown
        end
      end
    end
  end
end
