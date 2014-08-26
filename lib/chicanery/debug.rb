module Chicanery
  module Debug
    def verbose message
      return unless ENV['CHICANERY_DEBUG'] == 'verbose'
      $stderr.puts message
    end

    def verbose_blue message
      verbose message.colorize(:blue)
    end
  end
end
