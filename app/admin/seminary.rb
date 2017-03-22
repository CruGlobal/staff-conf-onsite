ActiveAdmin.register Seminary do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  permit_params(
    :name, :code, :course_price
  )

  filter :name
  filter :code
end
