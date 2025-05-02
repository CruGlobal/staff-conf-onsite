#PaperTrail.config.track_associations = false
# config/initializers/paper_trail.rb
PaperTrail::Version.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      # Explicitly list searchable attributes (excluding binary/object fields)
      %w[id item_type item_id event whodunnit created_at]
    end
  
    def self.ransackable_associations(auth_object = nil)
      [] # Disable association searching if not needed
    end
  end