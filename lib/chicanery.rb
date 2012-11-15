require 'yaml'

module Chicanery
  VERSION = "0.0.1"

  def execute *args
    load args.shift
    state = {
      jobs: []
    }
    servers.each do |server|
      state[:jobs] += server.jobs
    end
    File.open path, 'w' do |file|
      file.puts state.to_yaml
    end
  end

  def server new_server
    servers << new_server
  end

  def servers
    @servers ||= []
  end

  def persist_to path
    @path = path
  end

  def path
    @path || 'state'
  end
end