describe Chicanery::Summary do
  describe '#failure?' do
    let(:state) { {servers: {} } }

    before do
      state.extend Chicanery::Summary
    end

    it 'should be false if there are no jobs' do
      state.should_not have_failure
    end

    it 'should be false if there are no failures' do
      state[:servers][:server1] = {
        job1: { last_build_status: :success },
        job2: { last_build_status: :success }
      }
      state.should_not have_failure
    end

    it 'should be true if there is a single failure' do
      state[:servers][:server1] = {
        job1: { last_build_status: :failure },
        job2: { last_build_status: :success }
      }
      state.should have_failure
    end
  end
end