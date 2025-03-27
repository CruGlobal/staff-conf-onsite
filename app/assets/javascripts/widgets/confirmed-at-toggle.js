/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// One of the Housing Preference fields is "confirmed_at" the date at which the
// preferences were confirmed by an admin. Here we replace this input field with
// a toggle button that flips this field between null and today's date.

$(() => setupConfirmedAtToggleButton());

var setupConfirmedAtToggleButton = function() {
  const $input =
    $('form input[name="family[housing_preference_attributes][confirmed_at]"]');
  if (!$input.length) { return; }

  var $btn =
    $('<span class="confirmed_at__toggle">').
      on('click', () => toggleConfirmedAtToggleButton($input, $btn));

  $input.css('display', 'none').after($btn);

  return updateConfirmedAtToggleButtonLabel($btn, $input.val());
};


var toggleConfirmedAtToggleButton = function($input, $btn) {
  const value = $input.val().length ? '' : new Date().toISOString();
  $input.val(value);
  return updateConfirmedAtToggleButtonLabel($btn, value);
};


var updateConfirmedAtToggleButtonLabel = function($btn, value) {
  if (value.length) {
    return $btn.removeClass('no').addClass('yes').text('confirmed!');
  } else {
    return $btn.removeClass('yes').addClass('no').text('unconfirmed');
  }
};
