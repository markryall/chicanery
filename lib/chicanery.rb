if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-gem-adapter'
  SimpleCov.start 'gem'
end

require 'chicanery/persistence'
require 'chicanery/collections'
require 'chicanery/handlers'
require 'chicanery/state_comparison'

module Chicanery
  include Persistence
  include Collections
  include Handlers
  include StateComparison

  VERSION = "0.0.5"

  def execute args
    load args.shift
    poll_period = args.shift
    if poll_period   
      run_every poll_period.to_i
    else
      run
    end
  end

  def run_every poll_period
    begin
      loop do
        run
        sleep poll_period
      end
    rescue Interrupt
    end
  end

  def run 
    previous_state = restore
    current_state = {
      servers: {},
      repos: {}
    }
    repos.each do |repo|
      repo_state = repo.state
      compare_repo_state repo.name, repo_state, previous_state[:repos][repo.name] if previous_state[:repos]
      current_state[:repos][repo.name] = repo_state
    end
    servers.each do |server|
      current_jobs = server.jobs
      compare_jobs current_jobs, previous_state[:servers][server.name] if previous_state[:servers]
      current_state[:servers][server.name] = current_jobs
    end
    run_handlers.each {|handler| handler.call current_state }
    persist current_state 
  end

end