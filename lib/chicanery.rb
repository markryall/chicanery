if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-gem-adapter'
  SimpleCov.start 'gem'
end

require 'chicanery/persistence'
require 'chicanery/handlers'
require 'chicanery/servers'
require 'chicanery/state_comparison'
require 'chicanery/summary'

module Chicanery
  include Persistence
  include Handlers
  include Servers
  include StateComparison

  VERSION = "0.1.0"

  def poll_period seconds=nil
    @poll_period = seconds if seconds
    @poll_period
  end

  def execute args
    load args.shift
    run_every poll_period
  end

  def run_every poll_period
    begin
      loop do
        run
        break unless poll_period
        sleep poll_period
      end
    rescue Interrupt
    end
  end

  def run
    previous_state = restore
    current_state = {
      repos: {}
    }
    check_servers current_state, previous_state
    repos.each do |repo|
      repo_state = repo.state
      compare_repo_state repo.name, repo_state, previous_state[:repos][repo.name] if previous_state[:repos]
      current_state[:repos][repo.name] = repo_state
    end
    current_state.extend Chicanery::Summary
    run_handlers.each {|handler| handler.call current_state, previous_state }
    persist current_state
  end
end