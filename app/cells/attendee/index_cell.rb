class Attendee::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column(:student_number) { |a| code a.student_number }
    personal_columns
    contact_columns
    column :department
    column :seminary
    date_columns
  end

  private

  def personal_columns
    column :first_name
    column :last_name
    column(:family) { |a| link_to family_label(a.family), family_path(a.family) }
    column(:birthdate) { |a| birthdate_label(a) }
    column(:age, sortable: :birthdate) { |a| age(a) }
    column(:gender) { |a| gender_name(a.gender) }
  end

  def contact_columns
    column(:email) { |a| mail_to(a.email) }
    column(:phone) { |a| format_phone(a.phone) }
    column :emergency_contact
  end

  def date_columns
    column :arrived_at
    column :departed_at
    column :created_at
    column :updated_at
  end
end
