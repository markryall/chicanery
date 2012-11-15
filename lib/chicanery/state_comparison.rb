module Chicanery
  module StateComparison
    def compare_jobs current_jobs, previous_jobs
      return unless previous_jobs
      current_jobs.each do |job_name, job|
        compare_job job_name, job, previous_jobs[job_name]
      end
    end

    def compare_job name, current, previous
      return unless current[:last_build_time] > previous[:last_build_time]
      success_handlers.each {|handler| handler.call name, current } if current[:last_build_status] == :success
      failure_handlers.each {|handler| handler.call name, current } if current[:last_build_status] == :failure
    end
  end
end