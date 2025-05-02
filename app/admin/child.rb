ActiveAdmin.register Child do
  partial_view :index, :show, form: Person::FORM_OPTIONS

  menu parent: 'People', priority: 3

  includes :family

  scope :all, default: true
  scope :in_kidscare

  # We create through Families#show
  config.remove_action_item :new
  config.remove_action_item :new_show

  permit_params(
    :first_name, :middle_name, :last_name, :birthdate, :gender, :family_id, :parent_pickup,
    :needs_bed, :grade_level, :childcare_id, :arrived_at, :departed_at,
    :name_tag_first_name, :name_tag_last_name, :childcare_deposit,
    :childcare_comment, :rec_pass_start_at, :rec_pass_end_at, :forms_approved, :forms_approved_by,
    :tshirt_size,
    childcare_weeks: [], hot_lunch_weeks: [], 
    cost_adjustments_attributes: %i[
      id _destroy description person_id price percent cost_type
    ],
    childcare_medical_history_attributes: %i[
      id _destroy date allergy food_intolerance chronic_health_addl medications
      restrictions vip_meds vip_dev vip_strengths vip_challenges vip_mobility vip_walk medi_allergy
      vip_comm_addl vip_comm_small vip_comm_large vip_comm_directions vip_stress_addl
      vip_stress_behavior vip_calm vip_hobby vip_buddy vip_addl_info sunscreen_self sunscreen_assisted
      sunscreen_provided
    ] << ChildcareMedicalHistory.multi_selection_collections.transform_values { |_| [] },
    cru_student_medical_history_attributes: %i[
      id _destroy date parent_agree gtky_lunch gtky_signout gtky_sibling_signout gtky_sibling
      gtky_small_group_friend gtky_musical gtky_activities gtky_gain gtky_growth gtky_addl_info gtky_addl_challenges
      gtky_large_groups gtky_small_groups gtky_is_leader gtky_leader gtky_is_follower gtky_friends gtky_hesitant
      gtky_active gtky_reserved gtky_boundaries gtky_authority gtky_adapts gtky_allergies med_allergies
      food_allergies other_allergies health_concerns asthma migraines severe_allergy anorexia diabetes
      altitude concerns_misc cs_vip_meds cs_vip_dev cs_vip_strengths cs_vip_challenges
      cs_vip_mobility cs_vip_walk cs_vip_comm_addl cs_vip_comm_small cs_vip_comm_large
      cs_vip_comm_directions cs_vip_stress_addl cs_vip_stress_behavior
      cs_vip_calm cs_vip_sitting cs_vip_hobby cs_vip_buddy cs_vip_addl_info
    ] << CruStudentMedicalHistory.multi_selection_collections.transform_values { |_| [] },
    meal_exemptions_attributes: %i[
      id _destroy date meal_type
    ],
    stays_attributes: %i[
      id _destroy housing_unit_id arrived_at departed_at single_occupancy
      no_charge waive_minimum percentage comment
    ]
  )

  filter :last_name
  filter :first_name
  filter :birthdate
  filter :gender
  filter :parent_pickup
  filter :needs_bed
  filter :arrived_at
  filter :departed_at
  filter :childcare_class

  action_item :import_spreadsheet, only: :index do
    link_to 'Import Spreadsheet', new_spreadsheet_families_path if authorized?(:import, Family)
  end

  member_action :send_docusign, method: :post do
    child = Child.find(params[:id])
    redirect_to resource_path(params[:id]), alert: 'DocuSign envelope already sent' and return if child.pending_envelope?

    note = params[:message].presence
    recipient = params[:primary_parent] ? child.family.primary_person : child.family.primary_person&.spouse

    begin
      Childcare::SendDocusignEnvelope.new(child, note, recipient: recipient).call
    rescue Childcare::SendDocusignEnvelope::SendEnvelopeError
      notice = 'DocuSign envelope not sent because a valid envelope already exists'
    else
      notice = 'DocuSign envelope successfully queued for delivery'
    end

    redirect_to resource_path(params[:id]), notice: notice
  end

  member_action :void_docusign, method: :post do
    child = Child.find(params[:id])
    envelope = child.childcare_envelopes.last

    begin
      Childcare::VoidDocusignEnvelope.new(envelope).call
    rescue Childcare::VoidDocusignEnvelope::VoidEnvelopeError
      notice = 'DocuSign envelope void request failed, the envelope is already voided, declined or completed'
    else
      notice = 'DocuSign envelope void request successfully queued'
    end

    redirect_to resource_path(params[:id]), notice: notice
  end

  member_action :create_new_docusign, method: :post do
    child = Child.find(params[:id])
    envelope = child.childcare_envelopes.last
    envelope.delete

    note = params[:message].presence
    recipient = params[:primary_parent] ? child.family.primary_person : child.family.primary_person&.spouse

    begin
      Childcare::SendDocusignEnvelope.new(child, note, recipient: recipient).call
    rescue Childcare::SendDocusignEnvelope::SendEnvelopeError
      notice = 'DocuSign envelope not sent because a valid envelope already exists'
    else
      notice = 'DocuSign envelope successfully queued for delivery'
    end

    redirect_to resource_path(params[:id]), notice: notice
  end
end
