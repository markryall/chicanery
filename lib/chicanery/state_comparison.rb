module Chicanery
  module StateComparison
    def compare_repo_state name, current, previous
      return unless previous
      current.each do |branch, state|
        next unless previous[branch]
        notify_commit_handlers "#{name}/#{branch}", state, previous[branch] if state != previous[branch]
      end
    end
  end
end