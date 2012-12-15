describe Chicanery do
  include Chicanery

  describe '#run' do

    before do
      server double("Server A", :name => "A", :jobs => "A jobs")
      server double("Server B", :name => "B", :jobs => "B jobs")
      repo  double("repo X", :name => "X", :state => "X state")
      repo  double("repo Y", :name => "Y", :state => "Y state")
      when_run do |current_state|
         @current_state = current_state
      end
      @current_state = nil
    end

    before { stub!("restore").and_return({})}
    before { %w{persist}.each {|m| stub! m } }

    it "notifies when_run listeners of the current state of the servers jobs" do
      run
      @current_state[:servers]["A"].should == "A jobs"
      @current_state[:servers]["B"].should == "B jobs"
    end

    it "notifies when_run listeners of the current state of the repos" do
      run
      @current_state[:repos]["X"].should == "X state"
      @current_state[:repos]["Y"].should == "Y state"
    end

    #TESTS TODO
    # it restores previous state and records current state
    # it compares current state and previous state for each server
    # it compares current state and previous state for each server

  end

  describe '#run_every' do
    it "polls with a specified period" do
      should_receive(:run).exactly(3).times
      should_receive(:sleep).with(10).ordered
      should_receive(:sleep).with(10).ordered
      should_receive(:sleep).with(10).ordered.and_raise Interrupt
      run_every 10
    end
  end

end