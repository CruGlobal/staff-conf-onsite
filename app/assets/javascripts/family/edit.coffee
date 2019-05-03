pageAction 'families', 'form', ->
  $form = $('form')
  setupHousingTypeDynamicFields($form.find('.housing_preference_attributes'))


# Some fields are only relevant when the user chooses a certain type from the
# Housing Type select box. We hide/show those choices whenever the select's
# value is changed.
setupHousingTypeDynamicFields = ($form) ->
  $select = $form.find('select[name$="[housing_type]"]')
  $select.on 'change', -> showHideDynamicFields($form, $select.val())

  showHideDynamicFields($form, $select.val())


showHideDynamicFields = ($form, housingType) ->
  $form.find('.dynamic-field').hide()
  $form.find(".dynamic-field.for-#{housingType}").show()
