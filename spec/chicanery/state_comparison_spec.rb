describe Chicanery::StateComparison do
  include Chicanery::StateComparison

  describe '#compare_jobs' do
    let(:current_jobs) { {} }
    let(:previous_jobs) { {} }

    after { compare_jobs current_jobs, previous_jobs }

    it 'should do nothing when there are no jobs in current state' do
      should_not_receive :compare_job
      previous_jobs[:job] = {}
    end

    it 'should do nothing when there is no previous state' do
      should_not_receive :compare_job
      current_jobs[:job] = {}
    end
  end

  describe '#compare_job' do
    let(:current_job) { {last_build_time: Time.now } }
    let(:previous_job) { {last_build_time: (Time.now-1) } }

    after { compare_job 'name', current_job, previous_job }

    it 'should do nothing when build times are equal' do
      current_job[:last_build_time] = previous_job[:last_build_time] = Time.now
    end

    it 'should notify started_handlers when activity is now building when it was previously sleeping' do
      current_job[:activity] = :building
      previous_job[:activity] = :sleeping
      should_receive(:notify_started_handlers).with 'name', current_job
    end
  end
end