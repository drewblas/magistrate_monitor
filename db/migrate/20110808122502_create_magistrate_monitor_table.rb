class CreateMagistrateMonitorTable < ActiveRecord::Migration
  def change
    create_table :magistrate_supervisors do |t|
      t.string :name
      t.string :remote_ip
      
      t.text :status
      t.text :databag
      
      t.datetime :last_checkin_at
      t.timestamps
    end
    
    add_index :magistrate_supervisors, :name, :unique => true
  end
end
