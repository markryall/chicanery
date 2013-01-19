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
    end
  end
end