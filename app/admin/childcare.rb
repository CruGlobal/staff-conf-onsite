ActiveAdmin.register Childcare do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  permit_params :name, :teachers, :location, :room
end
