/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// @return {string} The value for a given query string parameter
// @param {string} selectedParam - The name of the query parameter
window.query_param = function(selectedParam) {
  const pageURL = decodeURIComponent(window.location.search.substring(1));
  const params = pageURL.split('&');

  for (var param of Array.from(params)) {
    var parameterName = param.split('=');

    if (parameterName[0] === selectedParam) {
      if (parameterName[1] === undefined) { return true; } else { return parameterName[1]; }
    }
  }
};
