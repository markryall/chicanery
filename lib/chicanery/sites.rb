require 'chicanery/handlers'
require 'chicanery/site'

module Chicanery
  module Sites
    include Handlers

    def sites
      @sites ||= []
    end

    def site *args
      sites << Chicanery::Site.new(*args)
    end

    def check_sites current_state, previous_state
      current_state[:sites] = {}
      sites.each do |site|
        begin
          content = site.get
          current_state[:sites][site.name] = :up
          notify_up_handlers site.name, site
          notify_recovered_handlers site.name, site if previous_state && previous_state[:sites] && previous_state[:sites][site.name] == :down
        rescue Exception => e
          p e
          current_state[:sites][site.name] = :down
          notify_down_handlers site.name, site
          notify_crashed_handlers site.name, site if previous_state && previous_state[:sites] && previous_state[:sites][site.name] == :up
        end
      end
    end
  end
end