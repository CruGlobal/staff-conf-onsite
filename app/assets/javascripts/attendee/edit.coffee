$ ->
  $form = $('#edit_attendee')
  return unless $form.length

  invertMealCheckboxes($form.find('.meals_attributes'))


invertMealCheckboxes = ($meals) ->
  $meals.find('.meals_attributes__warning').remove()

  $meals.find('.meals_attributes__destroy_toggle').each ->
    $destroyToggle = $(this)
    exists = !$destroyToggle.prop('checked')

    $addToggle = $('<span class="meals_attributes__add_toggle">')
    updateAddToggle($addToggle, exists)
    $addToggle.on 'click', ->
      exists = !exists
      $destroyToggle.prop('checked', !exists)
      updateAddToggle($addToggle, exists)

    $destroyToggle.css('display', 'none').after($addToggle)


updateAddToggle = ($input, exists) ->
  cssClass = "status_tag #{if exists then 'yes' else 'no'}"

  $input.removeClass().addClass("meals_attributes__add_toggle #{cssClass}")
  $input.text(if exists then 'YES' else 'NO')
