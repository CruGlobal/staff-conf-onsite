# This service accepts a spreadsheet file uploaded by a {User} and, for each
# row in that spreadsheet, either creates a new {Ministry} record, or updates
# an existing record. A new record is created is the +code+ in the spreadsheet
# doesn't belong to an existing +Ministry+. If it does belong to an existing
# +Ministry+, its +name+ will be updated with the name given in the
# spreadsheet.
#
# information about the hierarchy of {Ministry Ministries} in the system. Each
# row describes a single chain of Grandparent-parent-child-etc. relationship,
# where each cell in the row contains the +code+ of a +Ministry+ and each
# Ministry is the parent of the +Ministry+ in the cell to its right.
#
# == Context Input
#
# [+context.file+ [+ActionDispatch::Http::UploadedFile+]]
#   a file uploaded to the server by a {User}
class Ministry::ImportHierarchySpreadsheet
  include Interactor::Organizer

  organize ReadSpreadsheet,
           Ministry::UpdateParents
end
