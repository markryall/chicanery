module Chicanery
  module Handlers
    %w{run succeeded failed broken fixed}.each do |status|
      class_eval <<-EOF
        def when_#{status} &block
          #{status}_handlers << block
        end

        def #{status}_handlers
          @#{status}_handlers ||= []
        end

        def notify_#{status}_handlers *args
          #{status}_handlers.each {|handler| handler.call *args }
        end
      EOF
    end
  end
end