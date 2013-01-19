module Chicanery
  module Summary
    def has_failure?
      self[:servers].map do |name,jobs|
        jobs.map do |name, state|
          state[:last_build_status] == :failure
        end
      end.flatten.inject(false) {|v,a| v || a}
    end

    def site_down?
      self[:sites].map do |name, status|
        status == :down
      end.inject(false) {|v,a| v || a}
    end
  end
end