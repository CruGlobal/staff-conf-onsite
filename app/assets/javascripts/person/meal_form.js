/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const labels = {
  yes: 'exempt',
  no:  'accept'
};


$(function() {
  setupMealForm('attendee');
  return setupMealForm('child');
});


// @param {string} personType - "attendee" or "child"
var setupMealForm = function(personType) {
  const $form = $(`#new_${personType}, #edit_${personType}`);
  if (!$form.length) { return; }

  const $meals = $form.find('.meal_exemptions_attributes');
  invertMealCheckboxes($meals);
  return addNewMealButton(
    personType,
    $meals,
    $meals.find('table tbody'),
    $('#meal_exemptions_attributes__js').data('nextindex'),
    $('#meal_exemptions_attributes__js').data('types').split(',')
  );
};



// The nested Meal Exemptions form includes a checkbox for each record that,
// when checked, will delete the record. This functionality is the opposite of
// what we want. We want the user to check the records that they wants to exist,
// and uncheck the records that they want deleted.
//
// This function hides the "destroy" checkbox and creates a new toggle button
// which the user checks when they want the Meal Exemption to exist, and
// unchecks when they want the Meal Exemption record to be deleted (or not
// created).
var invertMealCheckboxes = function($meals) {
  $meals.find('.meal_exemptions_attributes__warning').remove();

  return $meals.find('.meal_exemptions_attributes__destroy_toggle').each(function() {
    const $destroyToggle = $(this);
    let exists = !$destroyToggle.prop('checked');

    const $addToggle = $('<span class="meal_exemptions_attributes__add_toggle">');
    updateAddToggle($addToggle, exists);
    $addToggle.on('click', function() {
      exists = !exists;
      $destroyToggle.prop('checked', !exists);
      return updateAddToggle($addToggle, exists);
    });

    return $destroyToggle.css('display', 'none').after($addToggle);
  });
};


// Update the new toggle button's label and class when the user clicks on it
var updateAddToggle = function($input, exists) {
  const cssClass = `status_tag ${exists ? 'yes' : 'no'}`;

  $input.
    removeClass().
    addClass(`meal_exemptions_attributes__add_toggle ${cssClass}`);
  return $input.text(exists ? labels.yes : labels.no);
};


// Adds a button to the bottom of the Meals sub-form which allow the user to add
// a new row of records. That is, a new day's worth of meal exemptions. When the
// user clicks this button, they are prompted to pick a date via the jQuery
// DatePicker widget and a new row is added for their chosen date.
//
// @param {string} personType - "attendee" or "child"
var addNewMealButton = function(personType, $meals, $table, nextIndex, types) {
  const $input = $('<input type="text">').css('display', 'none').datepicker({
    dateFormat: "yy-mm-dd",
    altFormat: "MM d"
  });
  $input.on('change', function() {
    const date = $input.datepicker('getDate');
    const $row =
      $('<tr class="meal_exemptions_attributes__new-row">').append(
        $('<td>').append(
          $('<strong>').text($.datepicker.formatDate('MM d', date))
        )
      );

    for (var type of Array.from(types)) {
      createNewMealTypeButton(personType, $row, type, nextIndex++, date);
    }
    return $table.append($row);
  });

  const $btn =
    $('<span class="meal_exemptions_attributes__new-btn">').
      text('Add Meal Exemptions').
      on('click', () => $input.datepicker('show'));

  return $meals.append($input).append($btn);
};


// Creates a new toggle button for a specific Meal Exemption on a specific day.
//
// @param {string} personType - "attendee" or "child"
// @param {jQuery} $row       - the jQuery row to add the new column to
// @param {string} type       - the Meal#meal_type of the exemption in this
//   column (ie: Breakfast, Lunch, or Dinner)
// @param {number} index      - the query string row index of this MealExemption
//   record.
// @param [Date} date         - the date of the new Meal Exemption record
var createNewMealTypeButton = function(personType, $row, type, index, date) {
  const name = `${personType}[meal_exemptions_attributes][${index}]`;
  let mealExists = true;

  const $destroyToggle =
    $('<input type="checkbox" class="meal_exemptions_attributes__add_toggle">').
      attr('name', `${name}[_destroy]`).
      css('display', 'none');

  const $addToggle =
    $('<span class="meal_exemptions_attributes__add_toggle status_tag yes">').
      text(labels.yes);

  $addToggle.on('click', function() {
    mealExists = !mealExists;
    $destroyToggle.prop('checked', !mealExists);
    return updateAddToggle($addToggle, mealExists);
  });

  return $row.append(
    $('<td>').append(
      $destroyToggle,
      $addToggle,

      // date
      $('<input type="hidden">').
        attr('name', `${name}[date]`).
        val($.datepicker.formatDate('yy-mm-dd', date)),
      // meal type
      $('<input type="hidden">').
        attr('name', `${name}[meal_type]`).
        val(type)
    )
  );
};
