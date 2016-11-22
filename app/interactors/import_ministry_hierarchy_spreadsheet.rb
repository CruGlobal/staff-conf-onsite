class ImportMinistryHierarchySpreadsheet
  include Interactor::Organizer

  organize ReadSpreadsheet,
           UpdateMinistryParents
end
