/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(function() {
  function initializeMoneyInput(node) {
    if (node.nodeType !== 1) return;

    // Handle if the inserted node itself is a money input
    if ($(node).is('[data-money-input]')) {
      setupPriceFormat(node);
    }

    // Handle any matching descendants
    $(node).find('[data-money-input]').each((_, elem) => setupPriceFormat(elem));
  }

  // Run once on page load
  $('[data-money-input]').each((_, elem) => setupPriceFormat(elem));

  // Setup MutationObserver
  const priceFormatObserver = new MutationObserver(mutations => {
    mutations.forEach(mutation => {
      mutation.addedNodes.forEach(initializeMoneyInput);
    });
  });

  priceFormatObserver.observe(document.body, {
    childList: true,
    subtree: true
  });
});


var setupPriceFormat = elem => $(elem).priceFormat({
  allowNegative: true,
  limit: 8,
  prefix: false
});
