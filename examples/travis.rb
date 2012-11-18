require 'chicanery/cctray'

server Chicanery::Cctray.new 'travis', 'https://api.travis-ci.org/repositories/markryall/chicanery/cc.xml'

when_started do |job_name, job|
  puts "#{job_name} build has started"
end

when_succeeded do |job_name, job|
  puts "#{job_name} has succeeded"
end

when_failed do |job_name, job|
  puts "#{job_name} has failed"
end

when_broken do |job_name, job|
  `afplay ~/build_sounds/ambulance.mp3`
  puts "#{job_name} is broken"
end

when_fixed do |job_name, job|
  `afplay ~/build_sounds/applause.mp3`
  puts "#{job_name} is fixed"
end