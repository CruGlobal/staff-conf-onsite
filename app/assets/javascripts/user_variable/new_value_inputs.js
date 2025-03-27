/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
pageAction('user_variables', 'form', function() {
  const $select = $('select[name="user_variable[value_type]"]');
  $select.on('change', function() { return showOnly($(this).val()); });
  return showOnly($select.val());
});

var showOnly = function(type) {
  const selected = $(`#user_variable_value_${type}_input`)[0];
  console.log(selected);

  return $('.js-value-input').each(function() {
    const $elem = $(this);
    const $input = $elem.find('input, select, textarea');

    if (this === selected) {
      $elem.show();
      return $input.attr('name', 'user_variable[value]');
    } else {
      $elem.hide();
      return $input.removeAttr('name');
    }
  });
};
