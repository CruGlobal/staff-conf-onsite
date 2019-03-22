require 'test_helper'

class ArrayValidatorTest < ActiveSupport::TestCase
  setup do
    @model = CruStudentMedicalHistory.create
    @array_attribute = :gtky_challenges
    @collection = CruStudentMedicalHistory.multi_selection_collections[@array_attribute]
  end

  test 'a blank array is valid' do
    @model.assign_attributes(@array_attribute => [])
    assert_equal true, @model.valid?
  end

  test 'a nil array is valid' do
    @model.assign_attributes(@array_attribute => nil)
    assert_equal true, @model.valid?
  end

  test 'array contains invalid values' do
    @model.assign_attributes(@array_attribute => [@collection.first, 'invalid one', 'invalid two'])
    assert_equal false, @model.valid?
    assert_equal ['does not accept invalid one and invalid two'], @model.errors[@array_attribute]
  end

  test 'array contains valid values' do
    @model.assign_attributes(@array_attribute => [@collection.first, @collection.second])
    assert_equal true, @model.valid?
    assert_equal [], @model.errors[@array_attribute]
  end

  test 'not an array is invalid' do
    @model.assign_attributes(@array_attribute => 'wut')
    assert_equal false, @model.valid?

    @model.assign_attributes(@array_attribute => @model)
    assert_equal false, @model.valid?
  end
end
