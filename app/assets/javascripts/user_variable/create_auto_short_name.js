/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
pageAction('user_variables', 'form', () => $('input#user_variable_code').on('change', function() {
  console.log($(this).val());
  return $('input#user_variable_short_name').val(
    $(this).val()
  );
}));

