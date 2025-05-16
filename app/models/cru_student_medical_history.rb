class CruStudentMedicalHistory < ApplicationRecord
  include AttributePresence
  include CollectionAttributes

  belongs_to :child, optional: true

  multi_selection_attributes gtky_challenges: ['Death', 'Divorce', 'Abuse', 'Anger issues', 'Anxiety', 'Eating disorder',
                                               'Major life change', 'Depression', 'Significant bullying', 'Behavioral issues',
                                               'Self harm', 'Bipolar disorder', 'Foster Adoption', 'Other', 'None of the above'],
                             cs_health_misc: ['ADHD', 'Adaptive equipment', 'Autism', 'Behavioral challenges', 'Developmental delay',
                                              'Down Syndrome', 'Extra assistance', 'Other', 'None of the above'],
                             cs_vip_comm: ['In simple phrases', 'In complete sentences', 'Other'],
                             cs_vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises', 'Heights', 'Changing schedule', 'Other', 'None of the above'],
                             cs_allergies: ['Eggs', 'Milk', 'Tree nuts', 'Fish/Shellfish', 'Peanuts', 'Wheat',
                                            'Insect sting', 'Pollen', 'Medications', 'Latex', 'Soy', 'Other', 'None of the above'],
                             cs_chronic_health: ['Asthma', 'Anorexia', 'Diabetes', 'Migraines', 'Epilepsy', 'Severe allergy', 'Other', 'None of the above']

  single_selection_attributes gtky_lunch: ['YES lunch on their own', 'NO lunch on their own'],
                              gtky_signout: %w[YES NO],
                              gtky_sibling: %w[Yes No],
                              gtky_leader: %w[Yes No],
                              gtky_musical: %w[Yes No],
                              gtky_allergies: %w[Yes No],
                              health_concerns: %w[Yes No],
                              crustu_forms_acknowledged: %w[Yes No],
                              cs_restriction_certified: %w[CruKids_certify_WITHres CruKids_certify_NOres]
end
