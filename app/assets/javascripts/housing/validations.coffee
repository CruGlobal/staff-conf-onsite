$ ->
  $('body.housing form').on 'submit', ->
    $form = $(this)
    clean = true
    $form.find('select[name$="[housing_unit_id]"]').each ->
      if $(this).val() == ''
        alert('All stays must have a housing unit selected')
        clean = false
    $form.find('select[name$="[arrived_at]"]').each ->
      if $(this).val() == ''
        alert('All stays must have an arrival date')
        clean = false
    $form.find('select[name$="[departed_at]"]').each ->
      if $(this).val() == ''
        alert('All stays must have an arrival date')
        clean = false

    clean