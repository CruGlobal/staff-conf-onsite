# Every Attendee and Child can be assigned to any number of HousingUnits for a
# given time period (known as a "Stay"). The fields applicable to a a given
# stay depend on the HousingType the user selects.
#
# Note: For a new form, the HousingUnit selector will show, "Please select...",
# but if a pre-existing Stay record has a null housing_unit_id attribute, it
# will show the text of the <select>'s <option value=""> elememt, ie:
# "Self-Provided."
containerSelector = '.has_many_container.stays'
itemSelector = '.inputs.has_many_fields'

$ ->
  $form = $(containerSelector)
  return unless $form.length


  #  Fetch data for housing lists
  window.$menu_loaded = $.get '/housing_units_list', (data) ->
    window.$housing_unit_hierarchy = data

  # Pre-existing Stays
  $.when($menu_loaded).then ->
    $form.find(itemSelector).each ->
      $container = $(this)
      setupDynamicFields($container, false)
      setupDurationCalculation($container)

  $('select[name$="[housing_type]"]').each ->
    $select = $(this)
    setupHousingDefaults($select.closest('.has_many_fields'))


  # When new Stay fields are added
  $(containerSelector).on 'DOMNodeInserted', (event) ->
    $container = $(event.target)
    if $(event.target).is("#{containerSelector} #{itemSelector}")
      setupDynamicFields($container, true)
      setupNewStayDefaults($container)
      setupDurationCalculation($container)

setupHousingDefaults = ($container) ->
  $person_id = $container.closest('div.column').find('input[name$="[id]"]')
  $person = $('#person_' + $person_id.val()).data('attributes')

  addDurationCallback($container, $person, 'arrived_at', 'Person Arrives:')
  addDurationCallback($container, $person, 'departed_at', 'Person Departs:')

setupNewStayDefaults = ($container) ->
  setupHousingDefaults($container)

  $family = $('#family_attributes').data('attributes')
  $housingTypeEnum = ['dormitory', 'apartment', 'self_provided']

  $housing_type = $housingTypeEnum[$family.housing_type]
  $container.find('select[name$="[housing_type]"]').val($housing_type)

  for id, obj of $housing_unit_hierarchy[$housing_type]
    if obj.name == $family.location1
      $facility = $container.find('select[name$="[housing_facility_id]"]')
      $facility.val(id)
      $facility.trigger("chosen:updated")

# Some fields are only relevant when the user chooses a certain type from the
# Housing Type select box. We hide/show those choices whenever the select's
# value is changed.
#
# @param {jQuery} $form - The HTML form that contains the elements to show/hide.
# @param {boolean} isNewForm - true if this form has been dynamically added to
#   the DOM, to enter a new Stay; false if this form represents a pre-existing
#   Stay.
setupDynamicFields = ($form, isNewForm) ->
  $type_select = $form.find('select[name$="[housing_type]"]')
  $facility_select = $form.find('select[name$="[housing_facility_id]"]')

  $type_select.on 'change', ->
    type = $type_select.val()
    showOnlyTypeFields($form, type)
    updateHousingFacilitiesSelect($form, type)

  $facility_select.on 'change', ->
    type = $type_select.val()
    updateHousingUnitsSelect($form, type, $facility_select.val())

  initializeValues($form, $type_select, isNewForm)

updateHousingFacilitiesSelect = ($form, housing_type) ->
  $select = $form.find('select[name$="[housing_facility_id]"]')
  $select.empty() # remove old options
  $select.append($("<option></option>"))
  $.each $housing_unit_hierarchy[housing_type], (id, obj) ->
    $select.append($("<option></option>").attr("value", id).text(obj.name))
  $select.trigger("chosen:updated")
  $select.trigger("change")

updateHousingUnitsSelect = ($form, housing_type, housing_facility_id) ->
  $select = $form.find('select[name$="[housing_unit_id]"]')
  $select.empty() # remove old options
  $select.append($("<option></option>"))
  if $housing_unit_hierarchy[housing_type][housing_facility_id]
    $.each $housing_unit_hierarchy[housing_type][housing_facility_id]['units'], (id, unit) ->
      console.log(unit[1])
      console.log(unit[0])
      $select.append($("<option></option>").attr("value", unit[1]).text(unit[0]))
  $select.trigger("chosen:updated")

# Hides all .dynamic-field elements, except those "for" the given type.
#
# @param {jQuery} $container - The HTML element that contains the elements to
#   show/hide.
# @param {String} type - The dynamic fields to be shown.
showOnlyTypeFields = ($container, type) ->
  $container.find('.dynamic-field').hide()
  $container.find(".dynamic-field.for-#{type}").show()
  $facilities_select = $container.find('select[name$="[housing_facility_id]"]')
  $unit_select = $container.find('select[name$="[housing_unit_id]"]')
  if type == 'self_provided'
# Hide housing facilities
    $facilities_select.val('')
    $facilities_select.closest('li').hide()

    # Hide housing unit
    $unit_select.val('')
    $unit_select.closest('li').hide()
  else
    $facilities_select.closest('li').show()
    $unit_select.closest('li').show()


# The dynamic values are managed in response to jQuery events, but when also
# need to initialize everything when the page first loads.
#
# @param {jQuery} $form - The HTML form that contains the elements to show/hide.
# @param {jQuery} $select - The HousingUnit HTML <select> element.
# @param {jQuery} $facilityName - An HTML element to write the currently
#   selected HousingFacility name to.
# @param {boolean} isNewForm - true if this form has been dynamically added to
#   the DOM, to enter a new Stay; false if this form represents a pre-existing
#   Stay.
initializeValues = ($form, $select, isNewForm) ->
  typeString = $select.val() || ''

  unless typeString.length
    showOnlyTypeFields($form, 'self_provided')
    return

  showOnlyTypeFields($form, typeString)

# Adds a "calculated field" showing the number of days between the Arrival and
# Departure dates. ie: the duration of the person's Stay.
#
# @param {jQuery} $form - The HTML form that contains the dates
setupDurationCalculation = ($form) ->
  $start = $form.find('input[name$="[arrived_at]"]')
  $end = $form.find('input[name$="[departed_at]"]')

  $endContainer = $end.closest('li')

  $duration = $('<span />').text('N/A')
  $durationContainer =
    $('<li class="input" />').append(
      $('<label class="label" />').text('Days'),
      $duration
    )

  $endContainer.after($durationContainer)

  updateDuration = ->
    $duration.text(
      if $start.val() && $end.val()
        startDate = new Date($start.val())
        endDate = new Date($end.val())

        duration = julianDayNumber(endDate) - julianDayNumber(startDate)
        "#{duration} #{duration == 1 and 'Day' or 'Days'}"
      else
        'N/A'
    )

  $start.on 'change', updateDuration
  $end.on 'change', updateDuration
  updateDuration()


julianDayNumber = (date) ->
# See http://stackoverflow.com/a/11760121/603806 for an explanation of this
# calculation
  Math.floor((date / 86400000) - (date.getTimezoneOffset() / 1440) + 2440587.5)

addDurationCallback = ($container, $person_attributes, type, hintPrefix) ->
  $target = $container.find("input[name$='[#{type}]']")

  $hint = $('<p class="inline-hints" />').insertAfter($target)
  update = ->
    date = $person_attributes[type]
    $target.val(date) unless $target.val().length
    $hint.text("#{hintPrefix} #{date}")

  $target.on('change', update)
  $target.each(update)


