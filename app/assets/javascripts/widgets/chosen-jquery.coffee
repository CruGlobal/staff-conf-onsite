$ ->
  $('body').on 'DOMNodeInserted', (event) -> setupChosenWidget(event.target)
  setupChosenWidget(document)


setupChosenWidget = (scope) ->
  $('select', scope).each( ->
    $elem = $(this)
    return if $elem.parent().hasClass('ui-datepicker-title')

    hasBlank = allow_single_deselect: $elem.find('option[value=""]').length
    
    if $elem.parent().hasClass('select_and_search')
      $elem.chosen(
        width:'80%'
        allow_single_deselect: hasBlank
      )
    else 
      $elem.chosen(
        allow_single_deselect: hasBlank
      )
  )
