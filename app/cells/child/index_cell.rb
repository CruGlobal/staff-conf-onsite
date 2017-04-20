class Child::IndexCell < ::IndexCell
  def show
    selectable_column

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
    column(:birthdate) { |c| birthdate_label(c) }
    column(:age, sortable: :birthdate) { |c| age(c) }
  end

  def date_columns
    column :arrived_at
    column :departed_at
    column :created_at
    column :updated_at
  end

  def childcare_column(child)
    return if child.too_old_for_childcare?
    collection = childcare_select_name_only

    model.active_admin_form_for child do |f|
      f.inputs do
        f.input :childcare_id,
                as: :select,
                collection: collection,
                label: false,
                input_html: { 'data-path' => child_path(child) }
      end
    end
  end

  def childcare_select_name_only
    Childcare.all.order(:name).map { |c| [c.name, c.id] }
  end
end
