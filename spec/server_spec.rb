require 'spec_helper'

describe "MagistrateMonitor::Server" do
  include Rack::Test::Methods
  
  # Eventually could be replaced with fixtures, but we only need this one
  before(:all) do
    MagistrateMonitor::Supervisor.delete_all
    @supervisor = MagistrateMonitor::Supervisor.create :name => 'foo'
    @supervisor.normalize_status_data!
    @supervisor.set_target_state!('running', 'worker1')
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
  
  it 'should get a supervisor' do
    get '/supervisors/foo'
    last_response.should be_ok
  end
  
  it 'should delete a supervisor' do
    supervisor = MagistrateMonitor::Supervisor.create :name => 'bar'
    
    post '/supervisors/bar/delete'
    last_response.status.should == 302
  end
  
  context 'api' do
    it 'should provide the databag' do
      get '/api/status/foo'
      
      last_response.should be_ok
      last_response.body.should == ActiveSupport::JSON.encode(@supervisor.databag)
    end
    
    it 'should record the incoming status' do
      status = {'workers' => {'worker2' => {'state' => 'running'}}}
      post '/api/status/bar', :status => ActiveSupport::JSON.encode( status )
      
      last_response.should be_ok

      s = MagistrateMonitor::Supervisor.find_by_name 'bar'
      s.status.should == status
    end
    
  end
end