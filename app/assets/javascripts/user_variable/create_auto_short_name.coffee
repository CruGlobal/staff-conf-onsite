pageAction 'user_variables', 'create', ->
  $('input#user_variable_code').on 'change', ->
    console.log $(this).val()
    $('input#user_variable_short_name').val(
      $(this).val()
    )

