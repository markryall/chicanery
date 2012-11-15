module Chicanery
  module Handlers
    def when_run &block
      run_handlers << block
    end

    def run_handlers
      @run_handlers ||= []
    end

    def when_succeeded &block
      success_handlers << block
    end

    def success_handlers
      @success_handlers ||= []
    end

    def when_failed &block
      failure_handlers << block
    end

    def failure_handlers
      @failure_handlers ||= []
    end
  end
end