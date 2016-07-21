require_relative 'spec_helper'

describe Chicanery do
  subject { Object.new.extend Chicanery }

  describe '#execute' do
    before do
      %w{load restore persist}.each {|m| subject.stub m }
    end

    after { subject.execute ['configuration'] }

    it 'should load configuration and exit immediately when nothing is configured no poll period is provided' do
      subject.should_receive(:load).with 'configuration'
    end

    it 'should restore previous state' do
      subject.should_receive(:restore)
    end

    it 'should persist new state' do
      subject.should_receive(:persist).with servers: {}, repos: {}, sites: {}
    end

    it 'should sleep for specified time when poll period is provided' do
      subject.should_receive(:sleep).with(10).and_raise Interrupt
      subject.poll_period 10
    end

    it "polls with a specified period" do
      subject.should_receive(:run).exactly(3).times
      subject.should_receive(:sleep).with(10).ordered
      subject.should_receive(:sleep).with(10).ordered
      subject.should_receive(:sleep).with(10).ordered.and_raise Interrupt
      subject.poll_period 10
    end
  end
end
