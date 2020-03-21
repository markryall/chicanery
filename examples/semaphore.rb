require "chicanery/semaphore"

include Chicanery::Semaphore

token = ENV.fetch("SEMAPHORE_TOKEN")
project_branch_1 = ENV.fetch("BRANCH_1")

semaphore(
  "build 1",
  "https://semaphoreci.com/api/v1/projects/#{project_branch_1}?auth_token=#{token}",
)

when_broken do |job_name, job|
  puts "#{job_name} is broken"
end

when_fixed do |job_name, job|
  puts "#{job_name} is fixed"
end

when_run do |state|
  require "pp"
  pp state
end
