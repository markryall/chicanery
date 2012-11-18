describe Chicanery::Persistence do
  include Chicanery::Persistence

  describe '#persist' do
    it 'should write state to disk as yaml' do
      file = stub 'file'
      state = stub 'state', to_yaml: :yaml
      File.should_receive(:open).with('state', 'w').and_yield file
      file.should_receive(:puts).with :yaml
      persist state
    end
  end

  describe '#restore' do
    it 'should return empty hash if state file does not exist' do
      File.should_receive(:exist?).with('state').and_return false
      restore.should == {}
    end

    it 'should read yaml from disk' do
      state = stub 'state'
      File.should_receive(:exist?).with('state').and_return true
      YAML.should_receive(:load_file).with('state').and_return state
      restore.should == state
    end
  end
end