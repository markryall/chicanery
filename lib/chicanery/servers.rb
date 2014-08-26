require 'chicanery/collections'
require 'chicanery/handlers'
require 'chicanery/debug'

module Chicanery
  module Servers
    include Collections
    include Handlers
    include Debug

    def check_servers current_state, previous_state
      current_state[:servers] = {}
      verbose_blue "Execution #{Time.now}"
      servers.each do |server|
        verbose "examining server #{server.name}"
        current_jobs = server.jobs
        if previous_state[:servers] && previous_state[:servers][server.name]
          compare_jobs current_jobs, previous_state[:servers][server.name]
        else
          verbose "\tno past server #{server.name} state for comparison"
        end
        current_state[:servers][server.name] = current_jobs
      end
    end

    def compare_jobs current_jobs, previous_jobs
      current_jobs.each do |job_name, job|
        verbose "\texamining job #{job_name} (now #{job[:activity]}, was #{job[:last_build_status]})"
        if previous_jobs[job_name]
          compare_job job_name, job, previous_jobs[job_name]
        else
          verbose "\tno past job #{job_name} state for comparison"
        end
      end
    end

    def compare_job name, current, previous
      if current[:activity] == :building
        verbose "\t\tcurrently building"
        hack_for_forgetful_ci current, previous
        if previous[:activity] == :sleeping
          notify_started_handlers name, current
        end
        return
      end
      unless current[:last_build_time] != previous[:last_build_time] || current[:last_build_status] != previous[:last_build_status]
        verbose "\t\tno change in timestamp or build status"
        return
      end
      verbose "\t\t#{previous[:last_build_status]} -> #{current[:last_build_status]}"
      notify_succeeded_handlers name, current if current[:last_build_status] == :success
      notify_failed_handlers name, current if current[:last_build_status] == :failure
      notify_broken_handlers name, current if current[:last_build_status] == :failure && previous[:last_build_status] == :success
      notify_fixed_handlers name, current if current[:last_build_status] == :success && previous[:last_build_status] == :failure
    end

    def hack_for_forgetful_ci current, previous
      # the following unfortunate hack is to compensate for cctray implementations (semaphore) which lose last build information when building
      return if current[:last_build_time] > 0
      verbose "\t\tcopying previous build content"
      %w(build_time build_status label).each do |property|
        key = "last_#{property}".to_sym
        current[key] = previous[key]
      end
    end
  end
end