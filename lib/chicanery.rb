if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-gem-adapter'
  SimpleCov.start 'gem'
end

require 'chicanery/persistence'
require 'chicanery/servers'
require 'chicanery/repos'
require 'chicanery/sites'
require 'chicanery/summary'

module Chicanery
  include Persistence
  include Servers
  include Repos
  include Sites

  VERSION = "0.1.2"

  def poll_period seconds=nil
    @poll_period = seconds if seconds
    @poll_period
  end

  def execute args
    begin
      load args.shift
      run_every poll_period
    rescue Interrupt
    end
  end

  def run_every poll_period
    loop do
      run
      break unless poll_period
      sleep poll_period
    end
  end

  def run
    previous_state = restore
    current_state = {}
    check_servers current_state, previous_state
    check_repos current_state, previous_state
    check_sites current_state, previous_state
    current_state.extend Chicanery::Summary
    run_handlers.each {|handler| handler.call current_state, previous_state }
    persist current_state
  end
end