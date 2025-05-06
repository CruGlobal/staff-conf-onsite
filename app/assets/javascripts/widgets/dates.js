/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// The number of days ahead of the start date to set the end date
const daysIncrement = 1;

$(() => setupAutomaticEndDates());


// Configures all "start date" inputs, so that when changed, if the associated
// "end date" input is empty, it's value is automatically set to the following
// day.
var setupAutomaticEndDates = function() {
  const $startAt = $('input[name$="[start_at]"]');

  if (!$startAt.length) { return; }

  return $startAt.each(function() {
    return setupSingleStartAtChangeEvent($(this));
  });
};


// Maps the given "start date" input with the "end date" input field in the same
// form.
// @param {jQuery} $startAt - an input element
var setupSingleStartAtChangeEvent = function($startAt) {
  const $form = $startAt.closest('form');
  const $endAt = $form.find('input[name$="[end_at]"]');

  if (!$endAt.length) { return; }

  return $startAt.on('change', function() {
    if (!$startAt.val().length) { return; }

    const date = $(this).datepicker('getDate');
    const format = $(this).datepicker('option', 'dateFormat');

    if (!$endAt.val().length) {
      const newDate = addDays(date, daysIncrement);
      return $endAt.val($.datepicker.formatDate(format, newDate));
    }
  });
};


// @param {Date} date   - the base Date to increment from
// @param {number} days - the number of days to add to the given date
// @return {Date} - a new Date set to the given number of days in advance of the
//   given date
var addDays = function(date, days) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
};
