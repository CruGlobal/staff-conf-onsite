pageAction 'families', 'new_spreadsheet', ->
  $('form').on 'submit', ->
    $(this).find('.spinner-widget').removeClass('hide')

