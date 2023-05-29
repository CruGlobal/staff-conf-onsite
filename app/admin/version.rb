ActiveAdmin.register PaperTrail::Version do
  partial_view :index, :show

  controller do
    def resource_class
      PaperTrail::Version
    end
  end
end
