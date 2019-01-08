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
        food_intolerance: @import.food_intolerance
      )
      person.childcare_medical_history = medicalHistory

    end
  end
end
