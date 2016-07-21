require_relative '../spec_helper'

describe Chicanery::Summary do
  let(:state) { {servers: {} } }

  before do
    state.extend Chicanery::Summary
  end

  describe '#failure?' do
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

  describe '#building?' do
    it 'should be false if there are no jobs' do
      state.should_not be_building
    end

    it 'should be false if all jobs are sleeping' do
      state[:servers][:server1] = {
        job1: { activity: :sleeping },
        job2: { activity: :sleeping }
      }
      state.should_not be_building
    end

    it 'should be true if there is a single job building' do
      state[:servers][:server1] = {
        job1: { activity: :sleeping },
        job2: { activity: :building }
      }
      state.should be_building
    end
  end
end
