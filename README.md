# Chicanery

This is a gem to trigger any kind of action in response to an interesting event in a software development project (such as build server events, commit events, deployment events, etc.).

State is persisted between executions so that it can be run as a simple polling process or can be scheduled to run regularly with crontab.

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

Currently only ci servers that can provide cctray.xml are supported.  This includes thoughtworks go, tddium, jenkins, cc.net and several others.

## Plans for world domination

* monitoring a git repository for push notifications
* monitoring a mercurial repository for push notifications
* monitoring a subversion repository for commit notifications
* monitoring heroku for deployment event notification
* integration with the blinky gem to control build light
* integration with more ci servers (atlassian bamboo, jetbrains team city, etc.)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
