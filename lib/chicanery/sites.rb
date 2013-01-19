require 'chicanery/collections'

module Chicanery
  module Sites
    include Collections

    def check_sites current_state, previous_state
      current_state[:sites] = {}
    end
  end
end