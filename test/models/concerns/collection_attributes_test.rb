require 'test_helper'

class CollectionAttributesTest < ActiveSupport::TestCase
  setup do
    @model = CruStudentMedicalHistory.create

    @single_selection_attribute = @model.class.single_selection_collections.keys.first
    @single_select_value_one = @model.class.single_selection_collections[@single_selection_attribute].first

    @multi_selection_attribute = @model.class.multi_selection_collections.keys.first
    @multi_select_value_one = @model.class.multi_selection_collections[@multi_selection_attribute].first
    @multi_select_value_two = @model.class.multi_selection_collections[@multi_selection_attribute].second
  end

  test '.single_selection_collections' do
    assert_equal({
                   gtky_lunch: ['YES lunch on their own', 'NO lunch on their own'],
                   gtky_signout: ['YES self sign out', 'NO self sign out'],
                   gtky_sibling: %w[Yes No],
                   gtky_leader: %w[Yes No],
                   gtky_musical: %w[Yes No],
                   gtky_allergies: %w[Yes No],
                   health_concerns: %w[Yes No]
                 }, @model.class.single_selection_collections)
  end

  test '.multi_selection_collections' do
    assert_equal({
                   gtky_challenges: ['Death', 'Divorce', 'Abuse', 'Anger issues', 'Anxiety', 'Eating disorder',
                                     'Major life change', 'Depression', 'Significant bullying', 'Behavioral challenges',
                                     'Self harm', 'Bipolar disorder', 'Foster Adoption', 'Other'],
                   cs_health_misc: ['Developmental delay', 'Sensory issues', 'Behavioral challenges', 'Disability',
                                    'Extra assistance', 'Adaptive equipment', 'None of the above'],
                   cs_vip_comm: ['In simple phrases', 'In complete sentences', 'Other'],
                   cs_vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises', 'Other']
                 }, @model.class.multi_selection_collections)
  end

  test 'validate single selection attribute' do
    @model.assign_attributes(@single_selection_attribute => 'invalid')
    assert_equal false, @model.valid?
    assert_equal ['is not included in the list'], @model.errors[@single_selection_attribute]

    @model.assign_attributes(@single_selection_attribute => @single_select_value_one)
    assert_equal true, @model.valid?
  end

  test 'validate multi selection attribute' do
    @model.assign_attributes(@multi_selection_attribute => ['invalid one', 'invalid two'])
    assert_equal false, @model.valid?
    assert_equal ['does not accept invalid one and invalid two'], @model.errors[@multi_selection_attribute]

    @model.assign_attributes(@multi_selection_attribute => [@multi_select_value_one, @multi_select_value_two])
    assert_equal true, @model.valid?
  end

  test 'write multi selection attribute with Array' do
    @model.send("#{@multi_selection_attribute}=", [])
    @model.save!
    @model.reload
    assert_equal [], @model.send(@multi_selection_attribute)

    @model.send("#{@multi_selection_attribute}=", [@multi_select_value_one, @multi_select_value_two])
    @model.save!
    @model.reload
    assert_equal [@multi_select_value_one, @multi_select_value_two], @model.send(@multi_selection_attribute)
  end

  test 'write multi selection attribute with String' do
    @model.send("#{@multi_selection_attribute}=", '')
    @model.save!
    @model.reload
    assert_equal [], @model.send(@multi_selection_attribute)

    @model.send("#{@multi_selection_attribute}=", "#{@multi_select_value_one}, #{@multi_select_value_two}")
    @model.save!
    @model.reload
    assert_equal [@multi_select_value_one, @multi_select_value_two], @model.send(@multi_selection_attribute)
  end

  test 'write multi selection attribute with nil' do
    @model.send("#{@multi_selection_attribute}=", nil)
    @model.save!
    @model.reload
    assert_nil @model.send(@multi_selection_attribute)
  end
end
