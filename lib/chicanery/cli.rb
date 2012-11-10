module Chicanery
  module Cli
    def self.execute *args
      load args.shift
    end
  end
end