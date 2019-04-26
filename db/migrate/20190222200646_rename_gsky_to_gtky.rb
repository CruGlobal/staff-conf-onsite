# GTKY is an acronym that stands for Getting To Know You.
class RenameGskyToGtky < ActiveRecord::Migration
  COLUMNS_NAMES = %w[
    gsky_lunch
    gsky_signout
    gsky_sibling_signout
    gsky_sibling
    gsky_small_group_friend
    gsky_musical
    gsky_activities
    gsky_gain
    gsky_growth
    gsky_addl_info
    gsky_challenges
    gsky_large_groups
    gsky_small_groups
    gsky_leader
    gsky_friends
    gsky_hesitant
    gsky_active
    gsky_reserved
    gsky_boundaries
    gsky_authority
    gsky_adapts
    gsky_allergies
  ]

  def up
    COLUMNS_NAMES.each do |columns_name|
      rename_column :cru_student_medical_histories, columns_name, columns_name.gsub('gsky', 'gtky')
    end
  end

  def down
    COLUMNS_NAMES.each do |columns_name|
      rename_column :cru_student_medical_histories, columns_name.gsub('gsky', 'gtky'), columns_name
    end
  end
end
