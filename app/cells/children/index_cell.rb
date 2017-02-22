module Children
  class IndexCell < ::IndexCell
    def show
      selectable_column

      column :id
      personal_columns
      column(:grade_level) { |c| grade_level_label(c) }
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
  end
end
