describe Chicanery::Servers do
  include Chicanery::Servers

  it 'should default to an empty list of servers' do
    servers.should == []
  end

  it 'should append to servers list' do
    server :server
    servers.should == [:server]
  end
end