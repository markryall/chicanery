describe Chicanery::Persistence do
  include Chicanery::Persistence

  let(:file) { double 'file' }
  let(:state) { double 'state', to_yaml: :yaml }
  let(:state_regex) { /.*\/state.*/ }

  describe '#persist' do
    it 'should write state to disk as yaml' do
      File.should_receive(:open).with(state_regex, 'w').and_yield file

      # fixme? internal Tempfile call?
      File.should_receive(:open).with(anything, anything, anything)

      file.should_receive(:puts).with :yaml
      persist state
    end

    it 'should persist state to where it is told' do
      persist_state_to 'foo'
      File.should_receive(:open).with('foo', 'w').and_yield file
      file.should_receive(:puts).with :yaml
      persist state
    end
  end

  describe '#restore' do
    it 'should return empty hash if state file does not exist' do
      File.should_receive(:exist?).with(state_regex).and_return false
      restore.should == {}
    end

    it 'should read yaml from disk' do
      File.should_receive(:exist?).with(state_regex).and_return true
      YAML.should_receive(:load_file).with(state_regex).and_return state
      restore.should == state
    end

    it 'should read yaml from another location if it is told to do so' do
      persist_state_to 'foo'
      File.should_receive(:exist?).with('foo').and_return true
      YAML.should_receive(:load_file).with('foo').and_return state
      restore.should == state
    end
  end
end
