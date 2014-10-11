require 'chicanery'

describe Chicanery::Collections do
  include Chicanery::Collections

  %w{server repo}.each do |entity|
    it "should default to an empty list of #{entity}s" do
      send("#{entity}s").should == []
    end

    it "should append to #{entity}s list" do
      send entity, :entity
      send("#{entity}s").should == [:entity]
    end
  end
end
