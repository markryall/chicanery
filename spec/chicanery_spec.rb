describe Chicanery do
  include Chicanery

  describe '#execute' do
    before { %w{load restore persist}.each {|m| stub! m } }

    it 'should load configuration and exit immediately when nothing is configured no poll period is provided' do
      should_receive(:load).with 'configuration'
      execute %w{configuration}
    end

    it 'should restore previous state' do
      should_receive(:restore)
      execute %w{configuration}
    end

    it 'should persist new state' do
      should_receive(:persist).with({
        servers: {},
        repos: {}
      })
      execute %w{configuration}
    end

    it 'should sleep for specified time when poll period is provided' do
      should_receive(:sleep).with(10).and_raise Interrupt
      execute %w{configuration 10}
    end
  end

end