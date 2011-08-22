module MagistrateMonitor
  class Supervisor < ActiveRecord::Base
    set_table_name 'magistrate_supervisors'
    
    serialize :status, Hash
    serialize :databag, Hash
    
    # This makes sure that:
    # All supervisors have a status that is a hash
    # If it has something else for whatever reason, the real object is put in a hash under the 'status' key
    def normalize_status_data!
      self.status ||= {}      
      self.status['workers'] ||= {}
      
      self.status['workers'].each do |k,v|
        unless v.is_a?(Hash)
          v = {'state' => v.inspect }
        end
      end
      
      self.databag ||= {}
      self.databag['workers'] ||= {}
    end
    
    def set_target_state!(action, worker)
      d = self.databag || {}
      d['workers'] ||= {}
      d['workers'][worker] = {'target_state' => action }
      self.update_attribute :databag, d
    end
  end
end