/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(function() {
  $.when($menu_loaded).then(function() {
    return $('#child_family_id, #attendee_family_id').autocomplete({
      source: $housing_families,
      select(event, ui) {
        return $(this).next('p').html(ui.item.label);
      }
    });});
  return $.when($ministries_loaded).then(function() {
    return $('#child_ministry_id, #attendee_ministry_id').autocomplete({
      source: $ministries,
      select(event, ui) {
        return $(this).next('p').html(ui.item.label);
      }
    });});});
