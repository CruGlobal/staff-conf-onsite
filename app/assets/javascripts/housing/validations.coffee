$ ->
  $('body.housing form').on 'submit', ->
    $form = $(this)
    $form.find('select[name$="[housing_unit_id]"]').each ->
      if $(this).val() == ''
        alert('All stays must have a housing unit selected')
        return false
    $form.find('select[name$="[arrived_at]"]').each ->
      if $(this).val() == ''
        alert('All stays must have an arrival date')
        return false
    $form.find('select[name$="[departed_at]"]').each ->
      if $(this).val() == ''
        alert('All stays must have an arrival date')
        return false