$(function () {
  function setupWidgetIfNeeded(node) {
    if (node.nodeType === 1) {
      setupChosenWidget(node);
    }
  }

  setupChosenWidget(document);

  const chosenObserver = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      mutation.addedNodes.forEach(setupWidgetIfNeeded);
    });
  });

  chosenObserver.observe(document.body, {
    childList: true,
    subtree: true
  });
});

function setupChosenWidget(scope) {
  $('select', scope).each(function () {
    const $elem = $(this);
    if ($elem.parent().hasClass('ui-datepicker-title')) return;

    const allowSingleDeselect = $elem.find('option[value=""]').length > 0;

    const chosenOptions = {
      allow_single_deselect: allowSingleDeselect,
      width: 'calc(80% - 22px)' 
    };
    console.log('Chosen options:', $elem);
    $elem.chosen(chosenOptions);
  });
}
