/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// Uses the gem 'intl-tel-input-rails' to provide a jQuery input helper for
// telephone numbers. If the page has a "country_code" selector, it will be
// synced with the telephone input, so if the user changes the country on one,
// it changes the other automatically.
$(function() {
  const $phone = $('input[type="tel"]');
  const $country = $('select[name*="country_code"]');
  const countryData = $.fn.intlTelInput.getCountryData();

  $phone.intlTelInput({
    formatOnInit: true,
    initialCountry: 'us'
  });

  // listen to the telephone input for changes
  $phone.on('countrychange', (e, countryData) => $country.val(countryData.iso2.toUpperCase()));

  // listen to the address dropdown for changes
  return $country.change(function() {
    return $phone.intlTelInput('setCountry', $(this).val().toLowerCase());
  });
});
