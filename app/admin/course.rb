ActiveAdmin.register Course do
  page_cells do |page|
    page.show
  end

  permit_params :name, :instructor, :description, :week_descriptor, :ibs_code,
                :price, :location

  index do
    selectable_column
    column :id
    column(:name) { |c| h4 c.name }
    column :instructor
    column(:price) { |c| humanized_money_with_symbol(c.price) }
    column(:description) { |c| html_summary(c.description) }
    column :week_descriptor
    column :ibs_code
    column :location
    column 'Attendees' do |c|
      link_to c.attendees.count, ''
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :instructor
  filter :description
  filter :week_descriptor
  filter :ibs_code
  filter :location
  filter :created_at
  filter :updated_at

  form do |f|
    show_errors_if_any(f)

    f.inputs do
      f.input :name
      f.input :instructor
      money_input_widget(f, :price)
      f.input :description, as: :ckeditor
      f.input :week_descriptor
      f.input :ibs_code
      f.input :location
    end
    f.actions
  end
end
