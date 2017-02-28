$ ->
  $('body').on 'DOMNodeInserted', (event) -> setupChosenWidget(event.target)
  setupChosenWidget(document)


setupChosenWidget = (scope) ->
  $('select', scope).each( ->
    hasBlank = allow_single_deselect: $(this).find('option[value=""]').length

    $(this).chosen(
      width: '80%'
      allow_single_deselect: hasBlank
    )
  )
