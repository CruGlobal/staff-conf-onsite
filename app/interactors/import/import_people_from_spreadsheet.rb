module Import
  class ImportPeopleFromSpreadsheet
    include Interactor::UploadJobOrganizer

    organize ReadSpreadsheet,
             ParsePeopleFromSpreadsheet,
             CreateNewPeopleRecords
  end
end
