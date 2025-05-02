module Import
  class UpdateMedicalHistoryFromImport < ApplicationService
    # +Person+
    attr_accessor :person

    # +Import::Person+
    attr_accessor :import

    def call
      set_childcare_medical_history_attributes
      set_student_medical_history_attributes
    end

    private

    def set_childcare_medical_history_attributes # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      childcare_medical_history = ChildcareMedicalHistory.new(
        allergy: @import.allergy,
        allergies: @import.allergies,
        medi_allergy: @import.medi_allergy,        
        chronic_health: @import.chronic_health,
        chronic_health_addl: @import.chronic_health_addl,
        medications: @import.medications,
        immunizations: @import.immunizations,
        non_immunizations: @import.non_immunizations,
        health_misc: @import.health_misc,
        restrictions: @import.restrictions,
        vip_strengths: @import.vip_strengths,
        vip_challenges: @import.vip_challenges,
        vip_mobility: @import.vip_mobility,
        vip_comm_small: @import.vip_comm_small,
        vip_comm_large: @import.vip_comm_large,
        vip_comm_directions: @import.vip_comm_directions,
        vip_stress: @import.vip_stress,
        vip_stress_addl: @import.vip_stress_addl,
        vip_stress_behavior: @import.vip_stress_behavior,
        vip_calm: @import.vip_calm,
        vip_hobby: @import.vip_hobby,
        vip_buddy: @import.vip_buddy,
        vip_addl_info: @import.vip_addl_info,
        restriction_certified: @import.restriction_certified,
        cc_vip_sitting: @import.cc_vip_sitting,
        vip_developmental_age: @import.vip_developmental_age
      )
      person.childcare_medical_history = childcare_medical_history
    end

    def set_student_medical_history_attributes # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      student_medical_history = CruStudentMedicalHistory.new(
        gtky_signout: @import.gtky_signout,
        gtky_sibling_signout: @import.gtky_sibling_signout,
        gtky_sibling: @import.gtky_sibling,
        gtky_small_group_friend: @import.gtky_small_group_friend,
        gtky_leader: @import.gtky_leader,
        gtky_activities: @import.gtky_activities,
        gtky_gain: @import.gtky_gain,
        gtky_growth: @import.gtky_growth,
        gtky_addl_info: @import.gtky_addl_info,
        gtky_challenges: @import.gtky_challenges,
        gtky_addl_challenges: @import.gtky_addl_challenges,
        gtky_large_groups: @import.gtky_large_groups,
        gtky_small_groups: @import.gtky_small_groups,
        gtky_is_leader: @import.gtky_is_leader,
        gtky_is_follower: @import.gtky_is_follower,
        gtky_friends: @import.gtky_friends,
        gtky_hesitant: @import.gtky_hesitant,
        gtky_active: @import.gtky_active,
        gtky_reserved: @import.gtky_reserved,
        gtky_boundaries: @import.gtky_boundaries,
        gtky_authority: @import.gtky_authority,
        gtky_adapts: @import.gtky_adapts,
        med_allergies: @import.med_allergies,
        med_allergy_multi: @import.med_allergy_multi,
        other_allergies: @import.other_allergies,
        crustu_forms_acknowledged: @import.crustu_forms_acknowledged,
        other_special_needs: @import.other_special_needs,
        cs_health_misc: @import.cs_health_misc,
        cs_vip_strengths: @import.cs_vip_strengths,
        cs_vip_challenges: @import.cs_vip_challenges,
        cs_vip_mobility: @import.cs_vip_mobility,
        cs_vip_comm_small: @import.cs_vip_comm_small,
        cs_vip_comm_large: @import.cs_vip_comm_large,
        cs_vip_comm_directions: @import.cs_vip_comm_directions,
        cs_vip_stress: @import.cs_vip_stress,
        cs_vip_stress_addl: @import.cs_vip_stress_addl,
        cs_vip_stress_behavior: @import.cs_vip_stress_behavior,
        cs_vip_calm: @import.cs_vip_calm,
        cs_vip_sitting: @import.cs_vip_sitting,
        cs_vip_hobby: @import.cs_vip_hobby,
        cs_vip_buddy: @import.cs_vip_buddy,
        cs_vip_addl_info: @import.cs_vip_addl_info
      )
      person.cru_student_medical_history = student_medical_history
    end
  end
end
