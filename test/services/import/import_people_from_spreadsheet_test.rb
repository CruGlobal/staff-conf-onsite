require 'test_helper'

class Import::ImportPeopleFromSpreadsheetTest < ServiceTestCase
  def around(&blk)
    create :conference, name: 'Cru17'
    create :ministry, code: 'FL33230'
    stub_default_seminary(&blk)
  end

  test 'single primary person, should create new Attendee' do
    assert_difference ->{ Attendee.count }, +2 do
      import_spreadsheet('people-import--single-primary-medical-history.csv')
    end

    @person = Attendee.first
    assert_equal 'Duane', @person.first_name
    assert_equal 'Abbott', @person.last_name
    assert_equal 'Duane', @person.name_tag_first_name
    assert_equal 'Abbott', @person.name_tag_last_name
    assert_equal 'm', @person.gender
    assert_equal Date.parse('20 Oct 1980'), @person.birthdate
    assert_equal 'White', @person.ethnicity
    assert_equal '5154738402', @person.phone
    assert_equal 'dabbott@familylife.com', @person.email
    assert_equal Date.parse('1 Aug 1999'), @person.hired_at
    assert_equal 'Staff Full Time', @person.employee_status
    assert_equal 'STFFD.LH.STAFF', @person.pay_chartfield
    assert_equal 'Registered', @person.conference_status
    assert_equal "Men's 2XL", @person.tshirt_size
  end

  test 'single child medical history, should create new Child with medical history' do
    assert_difference ->{ Child.count }, +2 do
      import_spreadsheet('people-import--single-primary-medical-history.csv')
    end

    @child = Child.first
    assert_equal 'Dairy', @child.cru_student_medical_history.med_allergies
    assert_equal 'Sometimes', @child.cru_student_medical_history.migraines
    assert_equal 'Yes', @child.cru_student_medical_history.anorexia
    assert_equal ['Death', 'Divorce', 'Abuse', 'Anger issues', 'Eating disorder', 'Significant bullying', 'Self harm'],
                 @child.cru_student_medical_history.gtky_challenges
    assert_equal 'YES lunch on their own', @child.cru_student_medical_history.gtky_lunch
    assert_equal 'More info about additional challenges.', @child.cru_student_medical_history.gtky_addl_challenges
  end

  test 'single student medical history, should create new Child with student medical history' do
    assert_difference ->{ Child.count }, +2 do
      import_spreadsheet('people-import--single-primary-medical-history.csv')
    end

    @child = Child.second
    assert_equal 'Peanuts', @child.childcare_medical_history.allergy
    assert_equal 'No Grains', @child.childcare_medical_history.restrictions
    assert_equal 'wheelchair', @child.childcare_medical_history.vip_mobility
    assert_equal ['Asthma', 'Other'], @child.childcare_medical_history.chronic_health
    assert_equal 'No', @child.childcare_medical_history.sunscreen_self
  end

  test 'single primary person, should create Family' do
    assert_difference ->{ Family.count }, +1 do
      import_spreadsheet('people-import--single-primary-medical-history.csv')
    end

    @family = Family.last
    assert_equal 'Abbott-65ad', @family.import_tag
    assert_equal '0638533', @family.staff_number
    assert_equal '114 Mountain Valley Dr', @family.address1
    assert_equal 'Maumelle', @family.city
    assert_equal 'AR', @family.state
    assert_equal '72113', @family.zip
    assert_equal 'US', @family.country_code
    assert_equal 'ABCD 1234', @family.license_plates
  end

  test 'single primary person, should create HousingPreference' do
    assert_difference ->{ HousingPreference.count }, +1 do
      import_spreadsheet('people-import--single-primary-medical-history.csv')
    end

    @family = Family.last
    assert_equal 'apartment', @family.housing_preference.housing_type
    assert_equal true, @family.housing_preference.single_room
    assert_equal 'My BFF <my@bff.com>', @family.housing_preference.roommates
    assert_equal false, @family.housing_preference.accepts_non_air_conditioned
    assert_equal 'First choice', @family.housing_preference.location1
    assert_equal 'Second choice', @family.housing_preference.location2
    assert_equal 'Third choice', @family.housing_preference.location3
    assert_equal 'This is my housing comment', @family.housing_preference.comment
    assert_equal 'Best Family Friends', @family.housing_preference.other_family
  end

  test 'import child' do
    import_spreadsheet('people-import--single-primary-medical-history.csv')

    assert_equal 'Melina', Child.first.middle_name
    assert_equal 'Child M', Child.first.tshirt_size
  end

  test 'import spouses' do
    assert_difference ->{ Family.count }, +1 do
      import_spreadsheet('people-import--single-primary-medical-history.csv')
    end

    @spouse_one = Family.last.attendees.first
    @spouse_two = Family.last.attendees.second

    assert_equal @spouse_two.id, @spouse_one.spouse_id
    assert_equal @spouse_one.id, @spouse_two.spouse_id
  end

  private

  def stub_default_seminary(&blk)
    Seminary.stub(:default, create(:seminary), &blk)
  end

  def import_spreadsheet(filename)
    path = Rails.root.join('test', 'fixtures', filename)

    Import::ImportPeopleFromSpreadsheet.call(
      job: UploadJob.create!(filename: path, user_id: 1)
    )
  end
end
