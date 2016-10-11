$ ->
  $form = $('#edit_attendee')
  return unless $form.length

  $meals = $form.find('.meals_attributes')
  invertMealCheckboxes($meals)
  addNewMealButton(
    $meals,
    $meals.find('table tbody'),
    $('#meals_attributes__js').data('nextid')
    $('#meals_attributes__js').data('types').split(',')
  )


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


addNewMealButton = ($meals, $table, nextId, types) ->
  $input = $('<input type="text">').css('display', 'none').datepicker(
    dateFormat: "yy-mm-dd"
    altFormat: "MM d"
  )
  $input.on 'change', ->
    date = $input.datepicker('getDate')
    $row =
      $('<tr class="meals_attributes__new-row">').append(
        $('<td>').append($('<strong>').text($.datepicker.formatDate('MM d', date)))
      )

    exists = {}
    for type in types
      createNewMealTypeButton($row, type, nextId++, date)
    $table.append($row)

  $btn = $('<span class="meals_attributes__new-btn">').text('New Meal Date').on 'click', ->
    $input.datepicker('show')

  $meals.append($input).append($btn)


createNewMealTypeButton = ($row, type, id, date) ->
  name = "attendee[meals_attributes][#{id}]"
  exists = true

  $destroyToggle =
      $("<input type='checkbox'>").
        attr('name', "#{name}[_destroy]").
        addClass('meals_attributes__add_toggle').
        css('display', 'none').
        append($('<span class="meals_attributes__add_toggle status_tag yes">').text('yes'))

  $addToggle = $('<span>').addClass('meals_attributes__add_toggle status_tag yes').text('yes')
  $addToggle.on 'click', ->
    exists = !exists
    $destroyToggle.prop('checked', !exists)
    updateAddToggle($addToggle, exists)

  $row.append(
    $('<td>').append(
      $destroyToggle,

      # date
      $('<input type="hidden">').
        attr('name', "#{name}[date]").
        val($.datepicker.formatDate('yy-mm-dd', date)),
      # meal type
      $('<input type="hidden">').
        attr('name', "#{name}[meal_type]").
        val(type),

      $addToggle
    )
  )
