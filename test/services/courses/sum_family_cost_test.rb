require 'test_helper'

class Course::SumFamilyCostTest < ServiceTestCase
  setup do
    @family = create :family_with_members

    @attendee_1 = @family.attendees.first
    @attendee_2 = @family.attendees.second    

    @attendee_1.update(seminary: create(:seminary, course_price_cents: 100_00))
    @attendee_2.update(seminary: create(:seminary, course_price_cents: 200_00))

    @service = Course::SumFamilyCost.new(family: @family)
  end

  test '1 course' do
    @attendee_1.course_attendances << create_course(price_cents: 123_00)
    @attendee_2.course_attendances = []
    @family.reload

    @service.call

    assert_equal Money.new(123_00), @service.total
  end

  test '1 course each' do
    @attendee_1.course_attendances << create_course(price_cents: 123_00)
    @attendee_2.course_attendances << create_course(price_cents: 234_00)
    @family.reload

    @service.call

    assert_equal Money.new(357_00), @service.total
  end

  test '2 courses each' do
    @attendee_1.course_attendances << create_course(price_cents: 123_00)
    @attendee_1.course_attendances << create_course(price_cents: 234_00)
    @attendee_2.course_attendances << create_course(price_cents: 234_00)
    @attendee_2.course_attendances << create_course(price_cents: 456_00)
    @family.reload

    @service.call

    assert_equal Money.new(1047_00), @service.total
  end

  test '1 course with credit' do
    @attendee_1.course_attendances << create_seminary_course(price_cents: 123_00)
    @attendee_2.course_attendances = []
    @family.reload

    @service.call

    assert_equal Money.new(223_00), @service.total
  end

  test '1 course each with credit' do
    @attendee_1.course_attendances << create_seminary_course(price_cents: 123_00)
    @attendee_2.course_attendances << create_seminary_course(price_cents: 234_00)
    @family.reload

    @service.call

    assert_equal Money.new(657_00), @service.total
  end

  test '2 courses each, 1 with credit' do
    @attendee_1.course_attendances << create_seminary_course(price_cents: 123_00)
    @attendee_1.course_attendances << create_course(price_cents: 234_00)
    @attendee_2.course_attendances << create_seminary_course(price_cents: 234_00)
    @attendee_2.course_attendances << create_course(price_cents: 456_00)
    @family.reload

    @service.call

    assert_equal Money.new(1347_00), @service.total
  end

  private

  def create_seminary_course(args = {})
    create_course(args.merge(seminary_credit: true))
  end

  def create_course(args = {})
    CourseAttendance.create(seminary_credit: args.delete(:seminary_credit),
                            course: create(:course, args))
  end
end
