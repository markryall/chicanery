require 'chicanery/cctray'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

describe Chicanery::Cctray do
  let(:server) do
    Chicanery::Cctray.new 'chicanery', 'https://api.travis-ci.org/repositories/markryall/chicanery/cc.xml'
  end

  it 'should detect idle build' do
    VCR.use_cassette('idle') do
      server.jobs.should == {
        "markryall/chicanery" => {
          activity: :sleeping,
          last_build_status: :success,
          last_build_time: 1355537908,
          url: "api.travis-ci.org/markryall/chicanery",
          last_label: "48"
        }
      }
    end
  end

  it 'should detect running build' do
    VCR.use_cassette('running') do
      server.jobs.should == {
        "markryall/chicanery" => {
          activity: :building,
          last_build_status: :unknown,
          last_build_time: nil,
          url: "api.travis-ci.org/markryall/chicanery",
          last_label: "49"
        }
      }
    end
  end

  it 'should detect failed build' do
    VCR.use_cassette('broken') do
      server.jobs.should == {
        "markryall/chicanery" => {
          activity: :sleeping,
          last_build_status: :failure,
          last_build_time: 1355539280,
          url: "api.travis-ci.org/markryall/chicanery",
          last_label: "50"
        }
      }
    end
  end

  it 'should complain if there are no jobs in response' do
     VCR.use_cassette('no_projects') do
       expect{server.jobs}.to raise_error "could not find any jobs in response: [Nothing here but us chickens]"
     end
  end

  it 'should complain if it gets a non 2xx response' do
     VCR.use_cassette('redirect') do
       expect{server.jobs}.to raise_error Net::HTTPRetriableError
     end
  end
end