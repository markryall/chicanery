module Chicanery
  module StateComparison
    def compare_jobs current_jobs, previous_jobs
      return unless previous_jobs
      current_jobs.each do |job_name, job|
        compare_job job_name, job, previous_jobs[job_name] if previous_jobs[job_name]
      end
    end

    def compare_job name, current, previous
      if current[:activity] == :building and previous[:activity] == :sleeping
        notify_started_handlers name, current
      end
      return unless current[:last_build_time] != previous[:last_build_time]
      notify_succeeded_handlers name, current if current[:last_build_status] == :success
      notify_failed_handlers name, current if current[:last_build_status] == :failure
      notify_broken_handlers name, current if current[:last_build_status] == :failure and previous[:last_build_status] == :success
      notify_fixed_handlers name, current if current[:last_build_status] == :success and previous[:last_build_status] == :failure
    end

    def compare_repo_state name, current, previous
      return unless previous
      current.each do |branch, state|
        next unless previous[branch]
        notify_commit_handlers "#{name}/#{branch}", state, previous[branch] if state != previous[branch]
      end
    end
  end
end