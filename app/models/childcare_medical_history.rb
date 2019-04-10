class ChildcareMedicalHistory < ApplicationRecord
  include AttributePresence
  include CollectionAttributes

  belongs_to :child

  multi_selection_attributes chronic_health: ['Asthma', 'Diabetes', 'Severe allergy', 'Other'],
                             immunizations: ['Yes'],
                             health_misc: ['Developmental delay', 'Sensory Processing Disorder', 'Behavioral issues',
                                           'Disability', 'Extra assistance', 'Adaptive equipment', 'None of the above'],
                             vip_comm: ['In simple phrases', 'In complete sentences', 'Visual schedule', 'Other'],
                             vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises',
                                          'Heights', 'Changing schedule', 'Other']

  single_selection_attributes sunscreen_self: %w[Yes No],
                              sunscreen_assisted: %w[Yes No],
                              sunscreen_provided: %w[Yes No]
end
