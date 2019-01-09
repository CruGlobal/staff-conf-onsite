module Import
  class UpdateMedicalHistoryFromImport < ApplicationService

    # +Person+
    attr_accessor :person

    # +Import::Person+
    attr_accessor :import

    def call
      set_medical_history_attributes
    end

    private

    def set_medical_history_attributes
      medicalHistory = ChildcareMedicalHistory.new(
        allergy: @import.allergy,
        food_intolerance: @import.food_intolerance,
        chronic_health: @import.chronic_health,
        chronic_health_addl: @import.chronic_health_addl,
        medications: @import.medications,
        immunizations: @import.immunizations,
        health_misc: @import.health_misc,
        restrictions: @import.restrictions,
        vip_meds: @import.vip_meds,
        vip_dev: @import.vip_dev,
        vip_strengths: @import.vip_strengths,
        vip_challenges: @import.vip_challenges,
        vip_mobility: @import.vip_mobility,
        vip_walk: @import.vip_walk,
        vip_comm: @import.vip_comm,
        vip_comm_addl: @import.vip_comm_addl,
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
        sunscreen_self: @import.sunscreen_self,
        sunscreen_assisted: @import.sunscreen_assisted,
        sunscreen_provided: @import.sunscreen_provided
      )
      person.childcare_medical_history = medicalHistory
    end

  end
end
