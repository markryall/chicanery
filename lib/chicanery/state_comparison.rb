module Chicanery
  module StateComparison
    def compare_jobs current_jobs, previous_jobs
      return unless previous_jobs
      current_jobs.each do |job_name, job|
        compare_job job_name, job, previous_jobs[job_name] if previous_jobs[job_name]
      end
    end

    def compare_job name, current, previous
      return unless current[:last_build_time] != previous[:last_build_time]
      if current[:activity] == :building and previous[:activity] == :sleeping
        notify_started_handlers name, current
        return
      end
      notify_succeeded_handlers name, current if current[:last_build_status] == :success
      notify_failed_handlers name, current if current[:last_build_status] == :failure
      notify_broken_handlers name, current if current[:last_build_status] == :failure and previous[:last_build_status] == :success
      notify_fixed_handlers name, current if current[:last_build_status] == :success and previous[:last_build_status] == :failure
    end

    def compare_repo_state name, current, previous
      current.each do |remote, branches|
        next unless previous[remote]
        branches.each do |branch, state|
          next unless previous[remote][branch]
          notify_commit_handlers "#{name}/#{remote}/#{branch}", state, previous[remote][branch] if state != previous[remote][branch]
        end
      end
    end
  end
end