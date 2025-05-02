ActiveAdmin.register PaperTrail::Version do
  partial_view :index, :show

  filter :item_type
  filter :item_id
  filter :event
  filter :whodunnit
  filter :created_at
  
  controller do
    def resource_class
      PaperTrail::Version
    end
  end
end
