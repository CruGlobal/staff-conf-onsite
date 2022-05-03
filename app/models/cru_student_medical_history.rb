class CruStudentMedicalHistory < ApplicationRecord
  include AttributePresence
  include CollectionAttributes

  belongs_to :child

  multi_selection_attributes gtky_challenges: ['Death', 'Divorce', 'Abuse', 'Anger issues', 'Anxiety', 'Eating disorder',
                                               'Major life change', 'Depression', 'Significant bullying', 'Behavioral issues',
                                               'Self harm', 'Bipolar disorder', 'Foster Adoption', 'Other'],
                             cs_health_misc: ['Developmental delay', 'Other special need', 'Behavioral issues', 'Disability',
                                              'Extra assistance', 'Adaptive equipment', 'None of the above'], ## removed Sensory issues, added Other special need
                             cs_vip_comm: ['In simple phrases', 'In complete sentences', 'Other'],
                             cs_vip_stress: ['Noisy spaces', 'Crowded spaces', 'Loud noises', 'Other']

  single_selection_attributes gtky_lunch: ['YES lunch on their own', 'NO lunch on their own'],
                              gtky_signout: ['YES self sign out', 'NO self sign out'],
                              gtky_sibling: %w[Yes No],
                              gtky_leader: %w[Yes No],
                              gtky_musical: %w[Yes No],
                              gtky_allergies: %w[Yes No],
                              health_concerns: %w[Yes No]
end
