class ChildcareMedicalHistory < ApplicationRecord
  include AttributePresence
  include CollectionAttributes

  belongs_to :child

  multi_selection_attributes chronic_health: ['Asthma', 'Diabetes', 'Severe allergy', 'Other'],
                             immunizations: ['Yes'],
                             health_misc: ['Developmental delay', 'Behavioral issues', 'Other special need',
                                           'Disability', 'Extra assistance', 'Adaptive equipment', 'None of the above'], ## removed sensory Processing Disorder, added Other special need
                             vip_comm: ['In simple phrases', 'In complete sentences', 'Other'],## removed Visual schedule 
                             vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises',
                                          'Heights', 'Changing schedule', 'Other']

  single_selection_attributes sunscreen_self: %w[Yes No],
                              sunscreen_assisted: %w[Yes No],
                              sunscreen_provided: %w[Yes No]
end
