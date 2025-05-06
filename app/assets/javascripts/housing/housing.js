/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// Every Attendee and Child can be assigned to any number of HousingUnits for a
// given time period (known as a "Stay"). The fields applicable to a a given
// stay depend on the HousingType the user selects.
//
// Note: For a new form, the HousingUnit selector will show, "Please select...",
// but if a pre-existing Stay record has a null housing_unit_id attribute, it
// will show the text of the <select>'s <option value=""> elememt, ie:
// "Self-Provided."
const containerSelector = '.has_many_container.stays';
const itemSelector = '.inputs.has_many_fields';

$(function() {
  // Set up search form
  const search = $('#housing_search_form').detach();
  if (!search) { return; }

  $('#titlebar_left').append(search);
  $('#housing_search_form').show();
  $('#search').on('keypress', function(e) {
    if (e.which === 13) {
      return false;
    }
  });

  const $form = $(containerSelector);

  // Pre-existing Stays
  $.when($menu_loaded).then(function() {
    $( "#search" ).autocomplete('option', 'source', $housing_families);
    $form.find(itemSelector).each(function() {
      const $container = $(this);
      setupDynamicFields($container, false);
      return setupDurationCalculation($container);
    });

    // All that excitement makes the form feel dirty
    return $('form').dirtyForms('setClean');
  });

  $('select[name$="[housing_type]"]').each(function() {
    const $select = $(this);
    return setupHousingDefaults($select.closest('.has_many_fields'));
  });

  // When new Stay fields are added
  return $(containerSelector).on('DOMNodeInserted', function(event) {
    const $container = $(event.target);
    if ($(event.target).is(`${containerSelector} ${itemSelector}`)) {
      setupDynamicFields($container, true);
      setupNewStayDefaults($container);
      return setupDurationCalculation($container);
    }
  });
});

var setupHousingDefaults = function($container) {
  const $person_id = $container.closest('div.column').
                          find('input[name$="[id]"]:not([id*="stays"])');
  const $person = $('#person_' + $person_id.val()).data('attributes');

  //  Adults always need a bed.
  if ($person.type !== 'Child') {
    $('input[name$="[no_bed]"]', $container).closest('li').remove();
  }

  addDurationCallback($container, $person, 'arrived_at', 'Person Arrives:');
  addDurationCallback($container, $person, 'departed_at', 'Person Departs:');

  return $person;
};

var setupNewStayDefaults = function($container) {
  const $person = setupHousingDefaults($container);

  const $family = $('#family_attributes').data('attributes');
  const $housingTypeEnum = ['dormitory', 'apartment', 'self_provided'];

  const $housing_type = $housingTypeEnum[$family.housing_type];
  const $ht_field = $container.find('select[name$="[housing_type]"]');
  $ht_field.val($housing_type);
  $ht_field.trigger('change');

  // Default no_bed to checked if the person record has false for needs_bed.
  if (!$person.needs_bed) {
    $('input[name$="[no_bed]"]', $container).attr('checked', 'checked');
  }

  return (() => {
    const result = [];
    for (var id in $housing_unit_hierarchy[$housing_type]) {
      var obj = $housing_unit_hierarchy[$housing_type][id];
      if (obj.name === $family.location1) {
        var $facility = $container.find('select[name$="[housing_facility_id]"]');
        $facility.val(id);
        result.push($facility.trigger("change"));
      } else {
        result.push(undefined);
      }
    }
    return result;
  })();
};

// Some fields are only relevant when the user chooses a certain type from the
// Housing Type select box. We hide/show those choices whenever the select's
// value is changed.
//
// @param {jQuery} $form - The HTML form that contains the elements to show/hide.
// @param {boolean} isNewForm - true if this form has been dynamically added to
//   the DOM, to enter a new Stay; false if this form represents a pre-existing
//   Stay.
var setupDynamicFields = function($form, isNewForm) {
  const $type_select = $form.find('select[name$="[housing_type]"]');
  const $facility_select = $form.find('select[name$="[housing_facility_id]"]');
  const $unit_select = $form.find('select[name$="[housing_unit_id]"]');

  $type_select.on('change', function() {
    const type = $type_select.val();
    showOnlyTypeFields($form, type);
    return updateHousingFacilitiesSelect($form, type);
  });

  $facility_select.on('change', function() {
    const type = $type_select.val();
    return updateHousingUnitsSelect($form, type, $(this).val());
  });

  $unit_select.on('change', function() {
    return updateHousingUnitMoreLink($form, $facility_select.val(), $(this));
  });

  return initializeValues($form, $type_select, isNewForm);
};

const setInitialHousingValues = function($container, $housing_type) {
  const $facility = updateHousingFacilitiesSelect($container, $housing_type);
  $facility.val($facility.data('value'));
  $facility.trigger("chosen:updated");
  $facility.trigger("change");

  const $housing_unit = $container.find('select[name$="[housing_unit_id]"]');
  $housing_unit.val($housing_unit.data('value'));
  return $housing_unit.trigger("chosen:updated");
};

var updateHousingFacilitiesSelect = function($form, $housing_type) {
  const $select = $form.find('select[name$="[housing_facility_id]"]');
  $select.empty(); // remove old options
  $select.append($("<option></option>"));
  $.each($housing_unit_hierarchy[$housing_type], (id, obj) => $select.append($("<option></option>").attr("value", id).text(obj.name)));
  $select.trigger("chosen:updated");
  $select.trigger("change");
  return $select;
};

var updateHousingUnitsSelect = function($form, housing_type, housing_facility_id) {
  const $select = $form.find('select[name$="[housing_unit_id]"]');
  $select.empty(); // remove old options
  $select.append($("<option></option>"));
  if ($housing_unit_hierarchy[housing_type][housing_facility_id]) {
    const units = $housing_unit_hierarchy[housing_type][housing_facility_id]['units'];
    $.each(units, (id, unit) => $select.append(
      $("<option></option>").attr("value", unit[1]).text(unit[0])
    ));
  }
  return $select.trigger("chosen:updated");
};

// Hides all .dynamic-field elements, except those "for" the given type.
//
// @param {jQuery} $container - The HTML element that contains the elements to
//   show/hide.
// @param {String} type - The dynamic fields to be shown.
var showOnlyTypeFields = function($container, type) {
  $container.find('.dynamic-field').hide();
  $container.find(`.dynamic-field.for-${type}`).show();
  const $facilities_select = $container.find('select[name$="[housing_facility_id]"]');
  const $unit_select = $container.find('select[name$="[housing_unit_id]"]');
  if (type === 'self_provided') {
// Hide housing facilities
    $facilities_select.val('');
    $facilities_select.closest('li').hide();

    // Hide housing unit
    $unit_select.val('');
    return $unit_select.closest('li').hide();
  } else {
    $facilities_select.closest('li').show();
    return $unit_select.closest('li').show();
  }
};


// The dynamic values are managed in response to jQuery events, but when also
// need to initialize everything when the page first loads.
//
// @param {jQuery} $form - The HTML form that contains the elements to show/hide.
// @param {jQuery} $select - The HousingUnit HTML <select> element.
// @param {jQuery} $facilityName - An HTML element to write the currently
//   selected HousingFacility name to.
// @param {boolean} isNewForm - true if this form has been dynamically added to
//   the DOM, to enter a new Stay; false if this form represents a pre-existing
//   Stay.
var initializeValues = function($form, $select, isNewForm) {
  const typeString = $select.val() || '';

  if (!typeString.length) {
    showOnlyTypeFields($form, 'self_provided');
    return;
  }

  showOnlyTypeFields($form, typeString);

  return setInitialHousingValues($form, typeString);
};

// Adds a "calculated field" showing the number of days between the Arrival and
// Departure dates. ie: the duration of the person's Stay.
//
// @param {jQuery} $form - The HTML form that contains the dates
var setupDurationCalculation = function($form) {
  const $start = $form.find('input[name$="[arrived_at]"]');
  const $end = $form.find('input[name$="[departed_at]"]');

  const $endContainer = $end.closest('li');

  const $duration = $('<span />').text('N/A');
  const $durationContainer =
    $('<li class="input" />').append(
      $('<label class="label" />').text('Days'),
      $duration
    );

  $endContainer.after($durationContainer);

  const updateDuration = () => $duration.text((() => {
    
    if ($start.val() && $end.val()) {
      const startDate = new Date($start.val());
      const endDate = new Date($end.val());

      const duration = julianDayNumber(endDate) - julianDayNumber(startDate);
      return `${duration} ${((duration === 1) && 'Day') || 'Days'}`;
    } else {
      return 'N/A';
    }
  
  })());

  $start.on('change', updateDuration);
  $end.on('change', updateDuration);
  return updateDuration();
};


var julianDayNumber = date => // See http://stackoverflow.com/a/11760121/603806 for an explanation of this
// calculation
Math.floor(((date / 86400000) - (date.getTimezoneOffset() / 1440)) + 2440587.5);

var addDurationCallback = function($container, $person_attributes, type, hintPrefix) {
  const $target = $container.find(`input[name$='[${type}]']`);

  const $hint = $('<p class="inline-hints" />').insertAfter($target);
  const update = function() {
    const date = $person_attributes[type];
    if (!$target.val().length) { $target.val(date); }
    return $hint.text(`${hintPrefix} ${date}`);
  };

  $target.on('change', update);
  return $target.each(update);
};

var updateHousingUnitMoreLink = function($container, $housing_facility_id, $housing_unit) {
  const $hint = $housing_unit.siblings('p');
  const update = function() {
    const housing_path = `/housing_facilities/${$housing_facility_id}`;
    const unit_path = `${housing_path}/housing_units/${$housing_unit.val()}`;

    return $hint.html(`<a href='${unit_path}' target='_blank'>Unit Info</a>`);
  };

  $housing_unit.on('change', update);
  return $housing_unit.each(update);
};

