require 'chicanery'

describe Chicanery do
  include Chicanery

  describe '#execute' do
    before { stub! :load }

    it 'should load configuration and exit immediately when nothing is configured no poll period is provided' do
      should_receive(:load).with 'configuration'
      execute 'configuration'
    end

    it 'should load configuration and exit immediately when nothing is configured no poll period is provided' do
      should_receive(:sleep).with(10).and_raise Interrupt
      execute 'configuration', '10'
    end
  end
end