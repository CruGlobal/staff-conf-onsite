ActiveAdmin.register Course do
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

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :name
          row :instructor
          row(:price) { |c| humanized_money_with_symbol(c.price) }
          row(:description) { |c| html_full(c.description) }
          row :week_descriptor
          row :ibs_code
          row :location
          row :created_at
          row :updated_at
        end
      end

      column do
        size = course.attendees.size
        panel "Attendees (#{size})" do
          if size.positive?
            ul do
              course.attendees.each do |a|
                li { link_to(a.full_name, a) }
              end
            end
          else
            strong 'None'
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :instructor
      f.input :price, as: :string
      f.input :description, as: :ckeditor
      f.input :week_descriptor
      f.input :ibs_code
      f.input :location
    end
    f.actions
  end
end
