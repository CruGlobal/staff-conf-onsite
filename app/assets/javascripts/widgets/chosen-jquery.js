/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(function() {
  $('body').on('DOMNodeInserted', event => setupChosenWidget(event.target));
  return setupChosenWidget(document);
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
