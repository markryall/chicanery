require 'chicanery/git'

include Chicanery::Git

git_repo 'chicanery', '.', branches: [:master]

start = Time.now.to_i
maximum = ARGV.shift.to_i

puts "Uncommitted changes will be automatically reverted after #{maximum} seconds"

when_run do |state|
  elapsed = Time.now.to_i - start
  if elapsed >= maximum
    puts "no commits detected in #{elapsed} seconds - reverting all uncommitted changes"
    `git reset --hard`
    start = Time.now.to_i
  end
end

when_commit do |branch, commit, previous|
  puts "commit detected - resetting timer"
  start = Time.now.to_i
end