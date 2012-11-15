module Chicanery
  module Servers
    def server new_server
      servers << new_server
    end

    def servers
      @servers ||= []
    end
  end
end