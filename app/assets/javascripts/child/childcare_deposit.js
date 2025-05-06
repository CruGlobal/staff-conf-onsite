/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__, or convert again using --optional-chaining
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// Automatically checks/unchecks the Childcare Deposit field if any Childcare
// Weeks are selected, with one exception: if it's checked on page-load, we
// won't uncheck it.
pageAction('children', 'form', function() {
  const $checkbox = $('#child_childcare_deposit');
  const $selector = $('#child_childcare_weeks');

  const checkedOnPageLoad = $checkbox.prop('checked');

  return $selector.on('change', function() {
    const childcareSelected = !!__guard__($(this).val(), x => x.length);
    return $checkbox.prop('checked', childcareSelected || checkedOnPageLoad);
  });
});

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}