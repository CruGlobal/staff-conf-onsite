/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const LIMITS = [10, 30, 50, 100, 200, 500, 1000, 5000, 10000, 100000];

// Creates a dropdown selector which allows the user to refresh the page,
// selecting how many records to display on each page
pageAction('index', () => $('.table_tools').append(perPageDropdown()));

var perPageDropdown = function() {
  let uri = document.URL;
  uri = updateQueryStringParameter(document.URL, 'page', 1);

  const $select = $('<select>').append(createOptions((Array.from(applicableLimits()).map((limit) => ({ value: optionsUrl(limit), name: `Records Per Page (${limit})` }))), optionsUrl(currentPerPage())));
  $select.on('change', () => window.location = $select.val()); 

  return $('<div class="dropdown_menu">').append($select);
};

var optionsUrl = function(limit) {
  let uri = document.URL;
  uri = updateQueryStringParameter(uri, 'page', 1);
  return updateQueryStringParameter(uri, 'per_page', limit);
};

var createOptions = (options, selected) => (() => {
  const result = [];
  for (var opt of Array.from(options)) {
    var $option = $('<option>').attr('value', opt['value']).text(opt['name']);
    result.push($option.prop('selected', selected === opt['value']));
  }
  return result;
})();

// Returns a subset of LIMITS containing only those numbers less than the total
// number of records
var applicableLimits = function() {
  const count = indexRecordsCount();
  const limits = (Array.from(LIMITS).filter((limit) => limit < count));
  limits.push(count);
  return limits;
};

var updateQueryStringParameter = function(uri, key, value) {
  const re = new RegExp(`([?&])${key}=.*?(&|$)`, 'i');
  const separator = uri.indexOf('?') !== -1 ? '&' : '?';

  if (uri.match(re)) {
    return uri.replace(re, `$1${key}=${value}$2`);
  } else {
    return `${uri}${separator}${key}=${value}`;
  }
};

// Return the current number of items shown
var currentPerPage = function() {
  const initial = Math.min(30, indexRecordsCount());
  return parseInt(query_param('per_page') || `${initial}`, 10);
};
