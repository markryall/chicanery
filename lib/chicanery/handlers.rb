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

    def when_broken &block
      broken_handlers << block
    end

    def broken_handlers
      @broken_handlers ||= []
    end

    def when_fixed &block
      fixed_handlers << block
    end

    def fixed_handlers
      @fixed_handlers ||= []
    end
  end
end