require 'chicanery/cctray'
require 'chicanery/git'

include Chicanery::Git

git_repo 'chicanery', 'git://github.com/markryall/chicanery.git'
server Chicanery::Cctray.new 'travis', 'https://api.travis-ci.org/repositories/markryall/chicanery/cc.xml'

def growlnotify message
  `growlnotify -t "some new chicanery ..." --image ~/icons/chicanery.png -m \"#{message}\"`
end

when_commit do |repo, commit, previous|
  growlnotify "commit #{previous}..#{commit} detected in repo #{repo}"
end

when_started do |job_name, job|
  growlnotify "job #{job_name} has started"
  `afplay ~/build_sounds/ticktock.mp3`
end

when_succeeded do |job_name, job|
  growlnotify "job #{job_name} #{job[:last_label]} has succeeded"
end

when_failed do |job_name, job|
  growlnotify "job #{job_name} #{job[:last_label]} has failed"
end

when_broken do |job_name, job|
  growlnotify "job #{job_name} is broken"
  `afplay ~/build_sounds/ambulance.mp3`
end

when_fixed do |job_name, job|
  growlnotify "job #{job_name} is fixed"
  `afplay ~/build_sounds/applause.mp3`
end