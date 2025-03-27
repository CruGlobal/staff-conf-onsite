/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const CHECK_MARK = '✔';
const CROSS_MARK = '✘';

pageAction('children', 'index', () => $('.col-childcare select').each(function() {
  return $(this).on('change', function() { return updateChildcareId(this); });
}));

// PATCH update the child's +childcare_id+
var updateChildcareId = function(element) {
  setAjaxStatus(element, null);

  const $select = $(element);
  const childcareId = $select.val();
  const path = $select.data('path');
  const csrf = $('meta[name="csrf-token"]').attr('content');

  return $.ajax({
    headers: {
      'X-CSRF-Token': csrf
    },
    url: path,
    type: 'PATCH',
    dataType: 'json', // the body is ignored anyway
    data: {
      child: {
        childcare_id: childcareId
      }
    }
  })
    .done(() => setAjaxStatus(element, 'good'))
    .fail(() => setAjaxStatus(element, 'bad'));
};

// Creates a label beside the select element that shows wether the AJAX request
// succeeded.
//
// @param {jQuery} element - the select element to annotate
// @param {string} status- 'good', 'bad', or null (to remove the status element)
var setAjaxStatus = function(element, status) {
  const $select = $(element);
  const $parent = $select.parent();

  let $label = $parent.find('.status_tag');
  if (!$label.length) { $label = $('<span class="status_tag">').appendTo($parent); }

  $label.removeClass('yes').removeClass('no');

  switch (status) {
    case 'good':
      $label.addClass('ok');
      return $label.text(CHECK_MARK);
    case 'bad':
      $label.addClass('error');
      return $label.text(CROSS_MARK);
    default:
      return $label.remove();
  }
};
