require 'chicanery/git'

include Chicanery::Git

git_repo 'chicanery', '.', branches: [:master]

def now
  Time.now.to_i
end

start = now
maximum = ARGV.shift.to_i

puts "Uncommitted changes will be automatically reverted after #{maximum} seconds"

when_run do |state|
  start = now if `git status`.chomp.split("\n").last == 'nothing to commit, working directory clean'
  elapsed = now - start
  if elapsed >= maximum
    puts "no commits detected in #{elapsed} seconds - reverting all uncommitted changes"
    `afplay ~/build_sounds/ticktock.mp3`
    `git reset --hard`
    `git clean -d -x -f`
    start = now
  end
end

when_commit do |branch, commit, previous|
  puts "commit detected - resetting timer"
  start = now
end