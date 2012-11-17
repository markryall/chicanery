# Chicanery

This is a command line tool to trigger any kind of action in response to any interesting event in a software development project (such as build server events, commit events, deployment events, etc.).

This is intended to run unattended on a server and is not really intended for local notifications on a developer's machine.  If this is what you're looking for, take a look at (build reactor)[https://github.com/AdamNowotny/BuildReactor] instead.

Any kind of action can be taken in response to these events - playing a sound, announcement in an irc session, firing a projectile at a developer, emitting an odour etc.

State is persisted between executions so that it be scheduled to run regularly with crontab or it can simply be run as a long polling process.

## Installation

    $ gem install chicanery

## Usage

Create a configuration file.  This file is just a ruby file that can make use of a few configuration and callback methods:

    require 'chicanery/cctray'

    server Chicanery::Cctray.new 'tddium', 'https://cihost.com/cctray.xml'

    when_succeeded do |job_name, job|
      post_antechamber 'ocelots', "#{job_name} [#{job[:last_label]}](#{job[:url]}) has **succeeded**"
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

Or continuously poll every 10 seconds:

    chicanery myconfiguration 10

You'll notice a file called 'state' is created which represents the state at the last execution.  This is then restored during the next execution to detect events such as a new build succeeding/failing.

## Supported CI servers

Currently only ci servers that can provide [cctray reporting format](http://confluence.public.thoughtworks.org/display/CI/Multiple+Project+Summary+Reporting+Standard] are supported.

This includes thoughtworks go, tddium, travisci, jenkins, cc.net and several others:

For a jenkins or hudson server, monitor http://<jenkins-server>:port/cc.xml

For a go server, monitor https://<go-server>:8154/go/cctray.xml

For a travis ci project, monitor http://travis-ci.org/<owner>/<project>/cc.xml

For a tddium project, monitor the link 'Configure with CCMenu' which will look something like https://api.tddium.com/cc/<long string>/cctray.xml

Basic authentication is supported by passing :user => 'user', :password => 'password' to the Chicanery::Cctray constructor.  https is supported without performing certificate verification (some ci servers such as thoughtworks go generates a self signed cert that would otherwise be rejected without significant messing around).

## Plans for world domination

* monitoring a git repository for push notifications
* monitoring a mercurial repository for push notifications
* monitoring a subversion repository for commit notifications
* monitoring heroku for deployment event notification
* monitoring more ci servers (atlassian bamboo, jetbrains team city, etc.)
* integration with the blinky gem to control a delcom build light
* other interesting notifier plugins or examples

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
