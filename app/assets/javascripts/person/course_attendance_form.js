/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const containerSelectorMain = '.has_many_container.course_attendances';
const itemSelectorMain = '.inputs.has_many_fields';

$(() => setupCourseAttendanceForm());


var setupCourseAttendanceForm = function() {
  const $form = $('#new_attendee, #edit_attendee');
  if (!$form.length) { return; }


  return $('body').on('DOMNodeInserted', function(event) {
    if ($(event.target).is(`${containerSelectormain} ${itemSelectorMain}`)) {
      return $(event.target).find('select').chosen({width: '80%'});
    }
  });
};
