module Chicanery
  VERSION = "0.0.1"

  def execute *args
    load args.shift
  end

  def ci server
    @servers ||= []
    @servers << server
  end
end
