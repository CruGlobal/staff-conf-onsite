showSpinner = ->
  $('form').on 'submit', ->
    $(this).find('.spinner-widget').removeClass('hide')

pageAction 'families', 'new_spreadsheet', showSpinner
pageAction 'housing_facilities', 'new_spreadsheet', showSpinner
