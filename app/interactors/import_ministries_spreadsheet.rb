class ImportMinistriesSpreadsheet
  include Interactor::Organizer

  organize ReadSpreadsheet,
           CreateOrUpdateMinistries
end
