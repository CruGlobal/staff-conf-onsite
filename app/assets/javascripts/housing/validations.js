/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(() => $('body.housing form').on('submit', function() {
  const $form = $(this);
  let clean = true;
  $form.find('select[name$="[housing_unit_id]"]').each(function() {
    const housing_type =
      $(this).closest('fieldset').find('select[name$="[housing_type]"]').val();
    if (($(this).val() === '') && (housing_type !== 'self_provided')) {
      alert('All stays must have a housing unit selected');
      return clean = false;
    }
  });
  $form.find('input[name$="[arrived_at]"]').each(function() {
    if ($(this).val() === '') {
      alert('All stays must have an arrival date');
      return clean = false;
    }
  });
  $form.find('input[name$="[departed_at]"]').each(function() {
    if ($(this).val() === '') {
      alert('All stays must have an departure date');
      return clean = false;
    }
  });

  return clean;
}));
