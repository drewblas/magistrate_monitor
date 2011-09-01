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
    
    def normalize_databag_for!(worker)
      d = self.databag || {}
      d['workers'] ||= {}
      d['workers'][worker] ||= {}
      self.databag = d
    end
    
    # This method abstracts access to a worker's databag.  It guarantees to return a hash of some sort useful for referencing worker properties
    # However, changes to this hash may not be propegated back.
    # Quite possibly it would be better to do checking here like in set_target_state! to normalize the data?
    def databag_for(worker)
      (self.databag['workers'].is_a?(Hash) ? self.databag['workers'][worker] : {}) || {}
    end
    
    def set_target_state!(action, worker)
      normalize_databag_for!(worker)
      self.databag['workers'][worker]['target_state'] = action
      self.update_attribute :databag, self.databag
    end
  end
end