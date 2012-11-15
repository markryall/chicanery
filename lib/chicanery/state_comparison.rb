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
      succeeded_handlers.each {|handler| handler.call name, current } if current[:last_build_status] == :success
      failed_handlers.each {|handler| handler.call name, current } if current[:last_build_status] == :failure
      broken_handlers.each {|handler| handler.call name, current } if current[:last_build_status] == :failure and previous[:last_build_status] == :success
      fixed_handlers.each {|handler| handler.call name, current } if current[:last_build_status] == :success and previous[:last_build_status] == :failure
    end
  end
end