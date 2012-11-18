require 'spec_helper'

describe Chicanery do
  include Chicanery

  describe '#execute' do
    before { %w{load restore persist}.each {|m| stub! m } }

    it 'should load configuration and exit immediately when nothing is configured no poll period is provided' do
      should_receive(:load).with 'configuration'
      execute 'configuration'
    end

    it 'should restore previous state' do
      should_receive(:restore)
      execute 'configuration'
    end

    it 'should persist new state' do
      should_receive(:persist).with({
        servers: {}
      })
      execute 'configuration'
    end

    it 'should sleep for specified time when poll period is provided' do
      should_receive(:sleep).with(10).and_raise Interrupt
      execute 'configuration', '10'
    end
  end
end