$ ->
  $('select').each( ->
    hasBlank = allow_single_deselect: $(this).find('option[value=""]').length

    $(this).chosen(
      width: '80%'
      allow_single_deselect: hasBlank
    )
  )
