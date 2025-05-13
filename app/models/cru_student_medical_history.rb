class CruStudentMedicalHistory < ApplicationRecord
  include AttributePresence
  include CollectionAttributes

  belongs_to :child, optional: true

  multi_selection_attributes gtky_challenges: ['Death', 'Divorce', 'Abuse', 'Anger issues', 'Anxiety', 'Eating disorder',
                                               'Major life change', 'Depression', 'Significant bullying', 'Behavioral issues',
                                               'Self harm', 'Bipolar disorder', 'Foster Adoption', 'Other', 'None of the above'],
                             cs_health_misc: ['Developmental delay', 'Other', 'Behavioral challenges', 'Disability',
                                              'Extra assistance', 'Adaptive equipment', 'None of the above', 'ADHD', 'Autism', 'Down Syndrome'],
                             cs_vip_comm: ['In simple phrases', 'In complete sentences', 'Other'],
                             cs_vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises', 'Heights', 'Changing schedule', 'Other', 'None of the above'],
                             cs_allergies: ['Eggs', 'Milk', 'Tree nuts', 'Fish/Shellfish', 'Peanuts', 'Wheat',
                                            'Insect sting', 'Pollen', 'Medications', 'Latex', 'Soy', 'Other', 'None of the above'],
                             cs_chronic_health: ['Asthma', 'Anorexia', 'Diabetes', 'Migraines', 'Epilepsy', 'Severe allergy', 'Other', 'None of the above']

  single_selection_attributes gtky_lunch: ['YES lunch on their own', 'NO lunch on their own'],
                              gtky_signout: ['YES self sign out', 'NO self sign out', 'YES', 'NO'],
                              gtky_sibling: %w[Yes No],
                              gtky_leader: %w[Yes No],
                              gtky_musical: %w[Yes No],
                              gtky_allergies: %w[Yes No],
                              health_concerns: %w[Yes No]
end
