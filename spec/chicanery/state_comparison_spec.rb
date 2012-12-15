describe Chicanery::StateComparison do
  include Chicanery::StateComparison

  it 'should fail' do
    1.should == 2
  end

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
    let(:current_job)  { { activity: :sleeping, last_build_time: 10 } }
    let(:previous_job) { { activity: :sleeping, last_build_time: 5  } }

    before {
      stub! :notify_failed_handlers
      stub! :notify_succeeded_handlers
    }

    after { compare_job 'name', current_job, previous_job }

    it 'should do nothing when build times are equal' do
      current_job[:last_build_time] = previous_job[:last_build_time] = Time.now
    end

    it 'should notify started handlers when activity changes to building' do
      current_job[:activity] = :building
      should_receive(:notify_started_handlers).with 'name', current_job
    end

    it 'should notify succeeded handlers when a build is successful' do
      current_job[:last_build_status] = :success
      should_receive(:notify_succeeded_handlers).with 'name', current_job
    end

    it 'should notify failed handlers when a build fails' do
      current_job[:last_build_status] = :failure
      should_receive(:notify_failed_handlers).with 'name', current_job
    end

    it 'should notify broken handlers when a build is broken' do
      previous_job[:last_build_status] = :success
      current_job[:last_build_status] = :failure
      should_receive(:notify_broken_handlers).with 'name', current_job
    end

    it 'should notify fixed handlers when a build is fixed' do
      previous_job[:last_build_status] = :failure
      current_job[:last_build_status] = :success
      should_receive(:notify_fixed_handlers).with 'name', current_job
    end
  end
end