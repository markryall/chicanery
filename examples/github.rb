require 'chicanery/git'

include Chicanery::Git

git_repo 'chicanery', '.', branches: [:master], remotes: {
  github: { url: 'git://github.com/markryall/chicanery.git' }
}

when_commit do |branch, commit, previous|
  puts "commit #{previous}..#{commit} detected in #{branch}"
end