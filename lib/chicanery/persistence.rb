require 'yaml'

module Chicanery
  module Persistence
    def persist state
      File.open 'state', 'w' do |file|
        file.puts state.to_yaml
      end
    end

    def restore
      return {} unless File.exist? 'state'
      YAML.load_file 'state'
    end
  end
end