require 'chicanery/cctray'

server Chicanery::Cctray.new 'travis', 'http://travis-ci.org/markryall/chicanery/cc.xml'

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