# Chicanery [![Build Status](https://secure.travis-ci.org/markryall/chicanery.png)](http://travis-ci.org/markryall/chicanery)

This is a command line tool to trigger any kind of action in response to any interesting event in a software development project (such as build server events, commit events, deployment events, etc.).

This is intended to run unattended on a server and is not really intended for local notifications on a developer's machine.  If this is what you're looking for, take a look at [build reactor](https://github.com/AdamNowotny/BuildReactor) instead.

Any kind of action can be taken in response to these events - playing a sound, announcement in an irc session, firing a projectile at a developer, emitting an odour etc.

State is persisted between executions so that it be scheduled to run regularly with crontab or it can simply be run as a long polling process.

## Installation

    $ gem install chicanery

## Usage

Create a configuration file.  This file is just a ruby file that can make use of a few configuration and callback methods:

    require 'chicanery/git'
    include Chicanery::Git
    git 'chicanery', '.', branches: [:master], remotes: {
      github: { url: 'git://github.com/markryall/chicanery.git' }
    }

    require 'chicanery/cctray'
    include Chicanery::Cctray
    cctray 'tddium', 'https://cihost.com/cctray.xml'

    when_run do |state|
      puts state.has_failure? ? "something is wrong" : "all builds are fine"
    end

    when_commit do |repo, commit, previous|
      puts "commit #{previous}..#{commit} detected in repo #{repo}"
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

Now you can schedule the following command with cron:

    chicanery myconfiguration

Or to continuously poll every 10 seconds, add the following line to the configuration:

    poll_period 10

You'll notice a file called 'state' is created which represents the state at the last execution.  This is then restored during the next execution to detect events such as a new build succeeding/failing.

If you want to specify an alternate location for this state file, add the following line to your configuration file:

    persist_state_to '/tmp/build_state'

# Callbacks

## General

The 'when_run' callback is executed on every poll.

## Servers

The following callbacks may be received after checking a CI server:

* when_started - when a new job has started
* when_succeeded - when a job finishes successfully
* when_failed - when a job finishes unsuccessfully
* when_broken - when a previously passing job fails
* when_fixed - when a previously failing job passes

## Repos

The following callbacks may be received after checking a source repository:

* when_commit - when a new commit is detected in the repository

Currently only git repositories are supported.

## Site

The following callbacks may be received after checking a web site:

* when_up - the website responded with a 2xx HTTP status
* when_down - the website did not responded with a 2xx HTTP status
* when_crashed - the website was previously up and is now down
* when_recovered - the website was previously down and is now up

## Supported CI servers

Currently only ci servers that can provide [Multiple Project Summary Reporting Standard](https://github.com/erikdoe/ccmenu/wiki/Multiple-Project-Summary-Reporting-Standard) are supported.

This includes thoughtworks go, tddium, travisci, circleci, jenkins, teamcity, cc.net and several others:

For a jenkins or hudson server, monitor http://jenkins-server:8080/cc.xml

For a go server, monitor https://go-server:8154/go/cctray.xml

For a travis ci project, monitor https://api.travis-ci.org/repositories/owner/project/cc.xml

For a tddium project, monitor the link 'Configure with CCMenu' which will look something like https://api.tddium.com/cc/long_uuid_string/cctray.xml

For team city, monitor the http://teamcity:8111/httpAuth/app/rest/cctray/projects.xml (requires credentials) or http://teamcity:8111/guestAuth/app/rest/cctray/projects.xml for guest. See [documentation](http://confluence.jetbrains.com/display/TW/REST+API+Plugin#RESTAPIPlugin-CCTray) for more information.

For a circleci project, monitor the links https://circleci.com/cc.xml?circle-token=:circle-token, https://circleci.com/gh/:owner/:repo.cc.xml?circle-token=:circle-token or https://circleci.com/gh/:owner/:repo/tree/:branch.cc.xml?circle-token=:circle-token.  See [documentation](https://circleci.com/docs/polling-project-status) for more details.

Basic authentication is supported by passing :user => 'user', :password => 'password' to the Chicanery::Cctray constructor.  https is supported without performing certificate verification (some ci servers such as thoughtworks go generates a self signed cert that would otherwise be rejected without significant messing around).  You can turn certificate verification back on by passing :verify_ssl => true.

## Plans for world domination

* monitoring a mercurial repository for push notifications
* monitoring a subversion repository for commit notifications
* monitoring more ci servers (atlassian bamboo, etc.)
* other interesting notifier plugins or examples

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
