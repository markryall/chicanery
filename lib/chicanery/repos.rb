require 'chicanery/collections'

module Chicanery
  module Repos
    include Collections

    def check_repos current_state, previous_state
      current_state[:repos] = {}
      repos.each do |repo|
        repo_state = repo.state
        compare_repo_state repo.name, repo_state, previous_state[:repos][repo.name] if previous_state[:repos]
        current_state[:repos][repo.name] = repo_state
      end
    end

    def compare_repo_state name, current, previous
      return unless previous
      current.each do |branch, state|
        next unless previous[branch]
        notify_commit_handlers "#{name}/#{branch}", state, previous[branch] if state != previous[branch]
      end
    end
  end
end