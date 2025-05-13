class ChildcareMedicalHistory < ApplicationRecord
  include AttributePresence
  include CollectionAttributes

  belongs_to :child

  multi_selection_attributes chronic_health: ['Asthma', 'Diabetes', 'Epilepsy', 'Severe allergy', 'Other', 'None of the above'],
                             immunizations: ['Yes'],
                             non_immunizations: ['Yes'],
                             health_misc: ['Developmental delay', 'Other', 'Behavioral challenges', 'Disability',
                             'Extra assistance', 'Adaptive equipment', 'None of the above', 'ADHD','Autism',
                             'Down Syndrome', 'Extra assistance'], ## removed sensory Processing Disorder, added Other special need
                             vip_comm: ['In simple phrases', 'In complete sentences', 'Other'],## removed Visual schedule 
                             vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises', 'Heights', 'Changing schedule', 'Other', 'None of the above'],
                             cc_allergies: ['Eggs', 'Milk', 'Tree nuts', 'Fish/Shellfish', 'Peanuts', 'Wheat',
                                       'Insect sting', 'Pollen', 'Medications', 'Latex', 'Soy', 'Other','None of the above']

  single_selection_attributes sunscreen_self: %w[Yes No],
                              sunscreen_assisted: %w[Yes No],
                              sunscreen_provided: %w[Yes No]
end
