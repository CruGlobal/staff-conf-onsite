/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
pageAction('families', 'form', function() {
  const $form = $('form');
  return setupHousingTypeDynamicFields($form.find('.housing_preference_attributes'));
});


// Some fields are only relevant when the user chooses a certain type from the
// Housing Type select box. We hide/show those choices whenever the select's
// value is changed.
var setupHousingTypeDynamicFields = function($form) {
  const $select = $form.find('select[name$="[housing_type]"]');
  $select.on('change', () => showHideDynamicFields($form, $select.val()));

  return showHideDynamicFields($form, $select.val());
};


var showHideDynamicFields = function($form, housingType) {
  $form.find('.dynamic-field').hide();
  return $form.find(`.dynamic-field.for-${housingType}`).show();
};
