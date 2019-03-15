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
  end

  test 'single student medical history, should create new Child with student medical history' do
    assert_difference ->{ Child.count }, +2 do
      import_spreadsheet('people-import--single-primary-medical-history.csv')
    end

    @student = Child.second
    assert_equal 'Peanuts', @student.childcare_medical_history.allergy
    assert_equal 'No Grains', @student.childcare_medical_history.restrictions
    assert_equal 'wheelchair', @student.childcare_medical_history.vip_mobility
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

  test 'import child' do
    import_spreadsheet('people-import--single-primary-medical-history.csv')

    assert_equal 'Melina', Child.first.middle_name
    assert_equal 'Child M', Child.first.tshirt_size
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
