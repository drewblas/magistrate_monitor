require "spec_helper"

describe "Supervisor" do
  before(:each) do
    MagistrateMonitor::Supervisor.delete_all
  end
  
  it 'should save to the DB successfully' do
    supervisor = MagistrateMonitor::Supervisor.new :name => 'foo'
    supervisor.save.should be_true
  end
  
  it 'should set a target state with a blank databag' do
    supervisor = MagistrateMonitor::Supervisor.new :name => 'foo'
    supervisor.set_target_state!('running', 'worker1')
    supervisor.reload
    
    supervisor.databag['workers']['worker1']['target_state'].should == 'running'
  end
  
  it 'should set target state multiple times successfully' do
    supervisor = MagistrateMonitor::Supervisor.new :name => 'foo'
    supervisor.set_target_state!('running', 'worker1')
    supervisor.set_target_state!('stopped', 'worker1')
    supervisor.reload
    
    supervisor.databag['workers']['worker1']['target_state'].should == 'stopped'
  end
  
  it 'should normalize the initial data' do
    supervisor = MagistrateMonitor::Supervisor.new :name => 'foo'
    
    supervisor.normalize_status_data!
    
    supervisor.databag.should be_a(Hash)
    supervisor.status.should be_a(Hash)
    supervisor.databag['workers'].should be_a(Hash)
  end
end