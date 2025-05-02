/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(function() {
  $('[data-money-input]').each((_, elem) => setupPriceFormat(elem));

  return $('body').on('DOMNodeInserted', event => $(event.target).find('[data-money-input]').each((_, elem) => setupPriceFormat(elem)));
});


var setupPriceFormat = elem => $(elem).priceFormat({
  allowNegative: true,
  limit: 8,
  prefix: false
});
