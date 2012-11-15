require 'chicanery/persistence'
require 'chicanery/servers'
require 'chicanery/handlers'
require 'chicanery/state_comparison'

module Chicanery
  include Persistence
  include Servers
  include Handlers
  include StateComparison

  VERSION = "0.0.2"

  def execute *args
    load args.shift
    previous_state = restore
    current_state = {
      servers: {}
    }
    servers.each do |server|
      current_jobs = server.jobs
      compare_jobs current_jobs, previous_state[:servers][server.name] if previous_state[:servers]
      current_state[:servers][server.name] = current_jobs
    end
    run_handlers.each {|handler| handler.call current_state }
    persist current_state
  end
end