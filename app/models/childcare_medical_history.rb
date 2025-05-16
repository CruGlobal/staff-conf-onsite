class ChildcareMedicalHistory < ApplicationRecord
  include AttributePresence
  include CollectionAttributes

  belongs_to :child

  multi_selection_attributes chronic_health: ['Asthma', 'Diabetes', 'Epilepsy', 'Severe allergy', 'Other', 'None of the above'],
                             immunizations: ['Yes'],
                             non_immunizations: ['Yes'],
                             health_misc: ['ADHD', 'Adaptive equipment', 'Autism', 'Behavioral challenges', 'Developmental delay',
                             'Down Syndrome', 'Extra assistance', 'Other', 'None of the above'],
                             vip_comm: ['In simple phrases', 'In complete sentences', 'Other'],## removed Visual schedule 
                             vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises', 'Heights', 'Changing schedule', 'Other', 'None of the above'],
                             cc_allergies: ['Eggs', 'Milk', 'Tree nuts', 'Fish/Shellfish', 'Peanuts', 'Wheat',
                                       'Insect sting', 'Pollen', 'Medications', 'Latex', 'Soy', 'Other','None of the above']
  single_selection_attributes cc_restriction_certified: %w[CruKids_certify_WITHres CruKids_certify_NOres]
                              
end
