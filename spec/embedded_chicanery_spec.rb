require_relative 'spec_helper'

describe Chicanery do
  subject { Object.new.extend Chicanery }

  describe '#run' do
    before do
      subject.server double("Server A", :name => "A", :jobs => "A jobs")
      subject.server double("Server B", :name => "B", :jobs => "B jobs")
      subject.repo  double("repo X", :name => "X", :state => "X state")
      subject.repo  double("repo Y", :name => "Y", :state => "Y state")
      subject.when_run do |current_state|
         @current_state = current_state
      end
      @current_state = nil
    end

    before do
      subject.stub("restore") { {} }
      subject.stub("persist")
    end

    it "notifies when_run listeners of the current state of the servers jobs" do
      subject.run
      @current_state[:servers]["A"].should == "A jobs"
      @current_state[:servers]["B"].should == "B jobs"
    end

    it "notifies when_run listeners of the current state of the repos" do
      subject.run
      @current_state[:repos]["X"].should == "X state"
      @current_state[:repos]["Y"].should == "Y state"
    end

    #TESTS TODO
    # it restores previous state and records current state
    # it compares current state and previous state for each server
    # it compares current state and previous state for each server
  end
end
