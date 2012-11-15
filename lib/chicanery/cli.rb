module Chicanery
  module Cli
    def execute *args
      load args.shift
    end
  end
end