require 'tempfile'
require 'yaml'

module Chicanery
  module Persistence
    def persist state
      File.open persist_state_to, 'w' do |file|
        file.puts state.to_yaml
      end
    end

    def restore
      return {} unless File.exist? persist_state_to
      YAML.load_file persist_state_to
    end

    def persist_state_to path=nil
      @state = path if path
      @state ||= Dir::Tmpname.make_tmpname './state', nil
    end
  end
end
