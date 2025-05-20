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


  const courseAttendanceObserver = new MutationObserver(function(mutations) {
  mutations.forEach(function(mutation) {
    mutation.addedNodes.forEach(function(node) {
      if (node.nodeType === 1 && $(node).is(`${containerSelectormain} ${itemSelectorMain}`)) {
        $(node).find('select').chosen({ width: '80%' });
      }
    });
  });
});

const container = document.querySelector('body'); // or limit to a more specific container if possible
if (container) {
  courseAttendanceObserver.observe(container, { childList: true, subtree: true });
}

};
