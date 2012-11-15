require 'chicanery/persistence'
require 'chicanery/servers'

module Chicanery
  include Persistence
  include Servers

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
    persist current
  end
end