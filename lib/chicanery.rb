require 'chicanery/persistence'
require 'chicanery/servers'
require 'chicanery/handlers'

module Chicanery
  include Persistence
  include Servers
  include Handlers

  VERSION = "0.0.1"

  def execute *args
    load args.shift
    previous = restore
    current = {
      jobs: []
    }
    servers.each do |server|
      current[:jobs] += server.jobs
    end
    run_handlers.each {|handler| handler.call current }
    persist current
  end
end