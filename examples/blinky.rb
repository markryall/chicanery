require 'blinky'
require 'chicanery/cctray'

include Chicanery::Cctray

cctray 'travis', 'https://api.travis-ci.org/repositories/markryall/chicanery/cc.xml'

when_run do |state|
  if state.has_failure?
    Blinky.new.light.failure!
  else
    Blinky.new.light.success!
  end
end