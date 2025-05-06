/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// Return the total number of records. Only works on an #index page
window.indexRecordsCount = function() {
  const count = $('.pagination_information b').last().text() || '0';
  return parseInt(count.match(/\d+/)[0], 10);
};
