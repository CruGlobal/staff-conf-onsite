class ApplicationCell < Cell::ViewModel
  include Rails.application.helpers
  include MoneyRails::ActionViewExtension

  property :l
end
