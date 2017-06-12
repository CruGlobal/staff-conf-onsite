$ ->
  $.when($menu_loaded).then ->
    $('#child_family_id, #attendee_family_id').autocomplete {
      source: $housing_families
    }
