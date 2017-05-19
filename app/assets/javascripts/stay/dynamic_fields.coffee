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

  # Pre-existing Stays
  $form.find(itemSelector).each ->
    setupDynamicFields($(this), false)
    setupDurationCalculation($(this))

  # When new Stay fields are added
  $('body').on 'DOMNodeInserted', (event) ->
    if $(event.target).is("#{containerSelector} #{itemSelector}")
      setupDynamicFields($(event.target), true)
      setupDurationCalculation($(event.target))
      setupDurationHints($(event.target))


# Some fields are only relevant when the user chooses a certain type from the
# Housing Type select box. We hide/show those choices whenever the select's
# value is changed.
#
# @param {jQuery} $form - The HTML form that contains the elements to show/hide.
# @param {boolean} isNewForm - true if this form has been dynamically added to
#   the DOM, to enter a new Stay; false if this form represents a pre-existing
#   Stay.
setupDynamicFields = ($form, isNewForm) ->
  $select = $form.find('select[name$="[housing_unit_id]"]')

  $facilityName = $('<p class="inline-hints" />')
  $select.parent().append($facilityName)

  # See app/assets/javascripts/housing/select_housing_unit.coffee for events
  $select.on 'change:housing_type', (_, type) -> showOnlyTypeFields($form, type)
  $select.on 'change:housing_facility', (_, name) -> $facilityName.text(name)

  initializeValues($form, $select, $facilityName, isNewForm)


# Hides all .dynamic-field elements, except those "for" the given type.
#
# @param {jQuery} $container - The HTML element that contains the elements to
#   show/hide.
# @param {String} type - The dynamic fields to be shown.
showOnlyTypeFields = ($container, type) ->
  $container.find('.dynamic-field').hide()
  $container.find(".dynamic-field.for-#{type}").show()


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
initializeValues = ($form, $select, $facilityName, isNewForm) ->
  idString = $select.data('value') || ''

  unless idString.length
    showOnlyTypeFields($form, 'self_provided')
    selectEmptyOption($select) unless isNewForm
    return

  id = parseInt(idString, 10)


  for type, facilities of $select.data('hierarchy')
    for facilityName, ids of facilities
      if $.inArray(id, ids) != -1
        showOnlyTypeFields($form, type.toLowerCase())
        $facilityName.text(facilityName)


# Updates the jQuery Dropdown widget to select the "empty" options. ie:
# Self-Provided.
#
# @param {jQuery} $select - The HousingUnit HTML <select> element.
selectEmptyOption = ($select) ->
  hierarchy = $select.data('hierarchy')
  dropdown = $select.data('dropdown-widget')

  emptyOption = null
  for type, facilities of hierarchy
    if $.isEmptyObject(facilities)
      emptyOption = type
      break
  return unless emptyOption

  for uid, item of dropdown.instance.items
    dropdown.select(item) if item.text == emptyOption


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
    $('<li class="inut" />').append(
      $('<label class="label" />').text('Requested Arrival/Departure'),
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


setupDurationHints = ($form) ->
