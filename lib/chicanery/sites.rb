require 'chicanery/collections'
require 'chicanery/handlers'

module Chicanery
  module Sites
    include Collections
    include Handlers

    def check_sites current_state, previous_state
      current_state[:sites] = {}
    end
  end
end