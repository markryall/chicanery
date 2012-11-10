module Chicanery
  module Cli
    def execute *args
      load args.shift
      loop do
        sleep 5
      end
    end
  end
end