require 'test_helper'

class Child::ShowTest < IntegrationTest
  include CostAdjustmentHelper

  setup do
    @user = create_login_user
    @child = create :child, birthdate: 5.years.ago
  end

  stub_user_variable child_age_cutoff: 6.months.from_now,
                     rec_center_daily: Money.new(1_00)

  test '#show details' do
    visit child_path(@child)

    assert_selector '#page_title', text: @child.full_name

    within('.panel', text: 'Child Details') do
      assert_show_rows :first_name, :last_name, :family, :gender, :birthdate,
                       :age, :grade_level, :parent_pickup, :needs_bed,
                       :created_at, :updated_at, :rec_pass_start_at,
                       :rec_pass_end_at,
                       selector: "#attributes_table_child_#{@child.id}"
    end

    within('.panel.duration') { assert_show_rows :arrived_at, :departed_at }
    within('.panel.childcare') { assert_show_rows :childcare, :childcare_weeks }

    assert_active_admin_comments
  end

  test '#show cost_adjustments when empty' do
    visit child_path(@child)
    within('.cost_adjustments.panel') { assert_text 'None' }
  end

  test '#show cost_adjustments' do
    @cost_adjustment = create :cost_adjustment, person: @child
    visit child_path(@child)
    cost_type = cost_type_name(@cost_adjustment.cost_type)
    within('.cost_adjustments.panel') { assert_text cost_type }
  end

  test '#show housing_assignments when empty' do
    visit child_path(@child)
    within('.stays.panel') { assert_text 'None' }
  end

  test '#show housing_assignments' do
    @housing_assignment = create :stay, person: @child
    visit child_path(@child)
    within('.stays.panel') { assert_text @housing_assignment.housing_unit.name }
  end
  
  test '#show send_docusign' do
    @parent1 = create :attendee, family: @child.family

    visit child_path(@child)
    within('.forms_approved.panel') { assert_text 'Send DocuSign Envelope' }
    within('.forms_approved.panel') { assert page.has_field?('message', type: 'textarea') }
    within('.forms_approved.panel') { assert page.has_button?("Send to #{@parent1.full_name}") }
  end

  test '#show send_docusign with two parents' do
    @parent1 = create :attendee, family: @child.family
    @parent2 = create :attendee, family: @child.family, spouse: @parent1
    @parent1.update(spouse: @parent2)

    visit child_path(@child)
    within('.forms_approved.panel') { assert_text 'Send DocuSign Envelope' }
    within('.forms_approved.panel') { assert page.has_field?('message', type: 'textarea') }
    within('.forms_approved.panel') { assert page.has_button?("Send to #{@parent1.full_name}") }
    within('.forms_approved.panel') { assert page.has_button?("Send to #{@parent2.full_name}") }
  end

  test '#show void_docusign when docusign sent' do
    @envelope = create :childcare_envelope, :sent, child: @child

    visit child_path(@child)
    within('.forms_approved.panel') { assert_text 'Docusign Envelope Sent To' }
    within('.forms_approved.panel') { assert_text @envelope.recipient.full_name }
    within('.forms_approved.panel') { assert page.has_button?('Void sent docusign envelope') }
  end

  test '#show create_new_docusign when docusign completed' do
    @envelope = create :childcare_envelope, :completed, child: @child
    @parent1 = create :attendee, family: @child.family

    visit child_path(@child)
    within('.forms_approved.panel') { assert_text 'Docusign Envelope Sent To And Completed By' }
    within('.forms_approved.panel') { assert_text @envelope.recipient.full_name }
    within('.forms_approved.panel') { assert page.has_field?('message', type: 'textarea') }
    within('.forms_approved.panel') { assert page.has_button?("Send to #{@parent1.full_name}") }
  end
end
