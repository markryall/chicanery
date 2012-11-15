module Chicanery
  module Handlers
    def when_run &block
      run_handlers << block
    end

    def run_handlers
      @run_handlers ||= []
    end
  end
end