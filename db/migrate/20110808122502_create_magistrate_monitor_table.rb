class CreateMagistrateMonitorTable < ActiveRecord::Migration
  def self.up
    create_table :magistrate_supervisors do |t|
      t.string :name
      t.string :remote_ip
      
      t.text :status
      t.text :databag
      
      t.datetime :last_checkin_at
      
      t.boolean :active, :default => true
      
      t.timestamps
    end
    
    add_index :magistrate_supervisors, :name, :unique => true
  end
  
  def self.down
    drop_table :magistrate_supervisors
  end
end
