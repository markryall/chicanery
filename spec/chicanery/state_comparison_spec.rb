describe Chicanery::StateComparison do
  include Chicanery::StateComparison

  let(:current_jobs) { {} }
  let(:previous_jobs) { {} }

  describe '#compare_jobs' do
    it 'should do nothing when there are no jobs in current state' do
      should_not_receive :compare_job
      previous_jobs[:job] = {}
      compare_jobs current_jobs, previous_jobs
    end

    it 'should do nothing when there is no previous state' do
      should_not_receive :compare_job
      current_jobs[:job] = {}
      compare_jobs current_jobs, previous_jobs
    end
  end
end