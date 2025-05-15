/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(function() {
  function setupWidgetIfNeeded(node) {
    // Only act on elements, not text nodes, etc.
    if (node.nodeType === 1) {
      setupChosenWidget(node);
    }
  }

  // Initialize on existing document
  setupChosenWidget(document);

  // Use MutationObserver to detect future inserts
  const chosenObserver = new MutationObserver(mutations => {
    mutations.forEach(mutation => {
      mutation.addedNodes.forEach(setupWidgetIfNeeded);
    });
  });

  chosenObserver.observe(document.body, {
    childList: true,
    subtree: true
  });
});



var setupChosenWidget = scope => $('select', scope).each( function() {
  const $elem = $(this);
  if ($elem.parent().hasClass('ui-datepicker-title')) { return; }

  const hasBlank = {allow_single_deselect: $elem.find('option[value=""]').length};
  
  if ($elem.parent().hasClass('select_and_search')) {
    return $elem.chosen({
      width:'80%',
      allow_single_deselect: hasBlank
    });
  } else { 
    return $elem.chosen({
      allow_single_deselect: hasBlank
    });
  }
});
