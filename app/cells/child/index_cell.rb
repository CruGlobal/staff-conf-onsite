class Child::IndexCell < ::IndexCell
  def show
    selectable_column

    column :id
    personal_columns
    column(:grade_level) { |c| grade_level_label(c) }
    column(:childcare) { |c| childcare_column(c) }
    column :parent_pickup
    column :needs_bed
    date_columns

    actions
  end

  private

  def personal_columns
    column :first_name
    column :last_name
    column(:family) { |c| link_to family_label(c.family), family_path(c.family) }
    column(:gender) { |c| gender_name(c.gender) }
    column :birthdate
    column(:age, sortable: :birthdate) { |c| age(c) }
  end

  def date_columns
    column :arrived_at
    column :departed_at
    column :created_at
    column :updated_at
  end

  def childcare_column(child)
    model.active_admin_form_for child do |f|
      f.inputs do
        f.input :childcare_id,
                as: :select,
                collection: childcare_spaces_select,
                include_blank: true,
                label: false,
                prompt: 'please select',
                input_html: { 'data-path' => child_path(child) }
      end
    end
  end
end