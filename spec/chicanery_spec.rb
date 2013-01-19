describe Chicanery do
  include Chicanery

  describe '#execute' do
    before { %w{load restore persist}.each {|m| stub! m } }

    after { execute ['configuration'] }

    it 'should load configuration and exit immediately when nothing is configured no poll period is provided' do
      should_receive(:load).with 'configuration'
    end

    it 'should restore previous state' do
      should_receive(:restore)
    end

    it 'should persist new state' do
      should_receive(:persist).with servers: {}, repos: {}, sites: {}
    end

    it 'should sleep for specified time when poll period is provided' do
      should_receive(:sleep).with(10).and_raise Interrupt
      poll_period 10
    end

    it "polls with a specified period" do
      should_receive(:run).exactly(3).times
      should_receive(:sleep).with(10).ordered
      should_receive(:sleep).with(10).ordered
      should_receive(:sleep).with(10).ordered.and_raise Interrupt
      poll_period 10
    end
  end
end
