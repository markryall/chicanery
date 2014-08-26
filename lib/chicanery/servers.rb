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
      verbose "Execution #{Time.now}"
      servers.each do |server|
        verbose "examining server #{server.name}"
        current_jobs = server.jobs
        compare_jobs current_jobs, previous_state[:servers][server.name] if previous_state[:servers]
        current_state[:servers][server.name] = current_jobs
      end
    end

    def compare_jobs current_jobs, previous_jobs
      unless previous_jobs
        verbose "\tno past state for comparison"
        return
      end
      current_jobs.each do |job_name, job|
        verbose "\texamining job #{job_name}"
        compare_job job_name, job, previous_jobs[job_name] if previous_jobs[job_name]
      end
    end

    def compare_job name, current, previous
      if current[:activity] == :building and previous[:activity] == :sleeping
        notify_started_handlers name, current
      end
      unless current[:last_build_time] != previous[:last_build_time]
        verbose "\t\tno change in timestamp"
        return
      end
      notify_succeeded_handlers name, current if current[:last_build_status] == :success
      notify_failed_handlers name, current if current[:last_build_status] == :failure
      notify_broken_handlers name, current if current[:last_build_status] == :failure and previous[:last_build_status] == :success
      notify_fixed_handlers name, current if current[:last_build_status] == :success and previous[:last_build_status] == :failure
    end
  end
end