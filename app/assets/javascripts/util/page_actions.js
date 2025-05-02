/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
let alreadyFired = false;
const registry = [];

// NOTE: 'form' is a special action which will match against either 'create',
// 'new', or 'edit'
window.pageAction = function(...args) {
  const len = args.length;
  const func = args[len - 1];
  const classes = args.slice(0, +(len - 2) + 1 || undefined);

  if (typeof(func) !== 'function') {
    throw new Error('last argument must be a function');
  }

  if (alreadyFired) {
    return fire(func, classes);
  } else {
    return registry.push({func, classes});
  }
};

var fire = function(func, classes) {
  if (bodyMatchAll(classes)) { return func($); }
};

var bodyMatchAll = function(classes) {
  for (var cl of Array.from(classes)) {
    if (!bodyMatch(cl)) { return false; }
  }
  return true;
};

var bodyMatch = function(cl) {
  if (cl === 'form') {
    return bodyMatch('create') || bodyMatch('new') || bodyMatch('edit');
  } else {
    return $(document.body).hasClass(cl);
  }
};

$(function() {
  alreadyFired = true;
  for (var r of Array.from(registry)) { fire(r.func, r.classes); }
  return $('form:not(#housing_search_form, #collection_selection)').dirtyForms();
});
