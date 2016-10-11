$ ->
  $form = $('#edit_attendee')
  return unless $form.length

  $meals = $form.find('.meals_attributes')
  invertMealCheckboxes($meals)
  addNewMealButton(
    $meals,
    $meals.find('table tbody'),
    $('#meals_attributes__js').data('nextindex')
    $('#meals_attributes__js').data('types').split(',')
  )


# The nested Meals form includes a checkbox for each record that, when checked,
# will delete the record. This functionality is the opposite of what we want. We
# want the user to check the records that they wants to exist, and uncheck the
# records that they want deleted.
#
# This function hides the "destroy" checkbox and creates a new toggle button
# which the user checks when they want the Meal to exist, and unchecks when
# they want the Meal record to be deleted (or not created).
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


# Update the new toggle button's label and class when the user clicks on it
updateAddToggle = ($input, exists) ->
  cssClass = "status_tag #{if exists then 'yes' else 'no'}"

  $input.removeClass().addClass("meals_attributes__add_toggle #{cssClass}")
  $input.text(if exists then 'YES' else 'NO')


# Adds a button to the bottom of the Meals sub-form which allow the user to add
# a new row of records. That is, a new day's worth of meals. When the user
# clicks this button, they are prompted to pick a date via the jQuery
# DatePicker widget and a new row is added for their chosen date.
addNewMealButton = ($meals, $table, nextIndex, types) ->
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

    for type in types
      createNewMealTypeButton($row, type, nextIndex++, date)
    $table.append($row)

  $btn =
    $('<span class="meals_attributes__new-btn">').
      text('New Meal Date').
      on('click', -> $input.datepicker('show'))

  $meals.append($input).append($btn)


# Creates a new toggle button for a specific meal on a specific day.
#
# @param {jQuery} $row  - the jQuery row to add the new column to
# @param {string} type  - the Meal#meal_type of the meal in this column (ie:
#   Breakfast, Lunch, or Dinner)
# @param {number} index - the query string row index of this Meal record.
# @param [Date} date    - the date of the new Meal record
createNewMealTypeButton = ($row, type, index, date) ->
  name = "attendee[meals_attributes][#{index}]"
  mealExists = true

  $destroyToggle =
    $('<input type="checkbox" class="meals_attributes__add_toggle">').
      attr('name', "#{name}[_destroy]").
      css('display', 'none')

  $addToggle =
    $('<span class="meals_attributes__add_toggle status_tag yes">').text('yes')

  $addToggle.on 'click', ->
    mealExists = !mealExists
    $destroyToggle.prop('checked', !mealExists)
    updateAddToggle($addToggle, mealExists)

  $row.append(
    $('<td>').append(
      $destroyToggle,
      $addToggle,

      # date
      $('<input type="hidden">').
        attr('name', "#{name}[date]").
        val($.datepicker.formatDate('yy-mm-dd', date)),
      # meal type
      $('<input type="hidden">').
        attr('name', "#{name}[meal_type]").
        val(type)
    )
  )
