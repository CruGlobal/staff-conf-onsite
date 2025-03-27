/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(function() {
  $('.summary span.title').each(function() {
    let url;
    const span = $(this);
    if (span.data('type') === 'Child') {
      url = '/children/';
    } else {
      url = '/attendees/';
    }
    url += span.data('id') + '/edit';
    const link = '<a href="' + url + '">' + span.html() + '</a>';
    return span.replaceWith(link);
  });

  return $('.summary.families form').on('submit', function() {
    const button = $('#checkin_button input', this);
    return button.replaceWith('Processing...');
  });
});