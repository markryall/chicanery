require 'chicanery'

describe Chicanery do
  include Chicanery

  describe '#execute' do
    it 'should load configuration and exit immediately when nothing is configured no poll period is provided' do
      should_receive(:load).with 'configuration'
      execute 'configuration'
    end
  end
end