module Import
  class ImportPeopleFromSpreadsheet
    include Interactor::Organizer

    organize ReadSpreadsheet,
             ParsePeopleFromSpreadsheet,
             CreateNewPeopleRecords
  end
end
