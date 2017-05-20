$ ->
  $('body').on 'DOMNodeInserted', (event) ->
    $select = $(event.target).find('[data-housing_unit-id]')
    setupHousingUnitSelectWidth($select) if $select.length
    $(event.target).find('select[name$="[housing_type]"]').each -> setupHousingTypeFields($(this))

  $('select[name$="[housing_type]"]').each -> setupHousingTypeFields($(this))


#  window.$menu_loaded = $.get '/housing_units_list', (data) ->
#    window.$housing_units_list = $(data)

setupHousingTypeFields = ($select) ->
  $select.chosen('destroy')

setupHousingUnitSelectWidth = ($select) ->
#  widget = new HousingUnitSelectWidget($select, $housing_labels)
  widget.addDurationCallbacks()


# Creates a multi-level select widget which lets the user "drill-down" to a
# HousingUnit.  The levels are:
#  1. Housing Type
#  2. Housing Facility
#  3. Housing Unit (room/apartment)
class HousingUnitSelectWidget
  # @param {JQuery} $select - The element to control with this widget.
  # @param {Object.<number, Object>} hierarchy - A tree where each key is a
  #   Housing Type and each value is an object containing a sub-tree of Housing
  #   Facilities. A Facilities's sub-tree contains all its HousingUnits.
  # @param {Object.<number, string>} labels - A map of unit DB IDs to their
  #   name.
  constructor: (@$select, @labels) ->


  widget: -> @$select.data('dropdown-widget')


  # Creates the UI widget and replaces the HTML select element with it
  replaceCodeSelectWithMultiLevelSelect: ->
    $menu = @$select.siblings('ul').first()
    console.log($menu)

    @setupDropdownPlugin($menu, @labels[@$select.val()])
    @addCallbacks($menu)

    $menu.select(
      $menu.data('dw.plugin.dropdown').selected()
    )


  setupDropdownPlugin: ($menu, initialSelection) ->
    $menu.on 'dropdown-init', (_, dropdown) =>
      @$select.data('dropdown-widget', dropdown)
      @setDefaultSelection(dropdown, initialSelection)
    $menu.dropdown()


  # Sets the currently value of the UI widget to match the current value of the
  # <select> element that it controls.
  setDefaultSelection: (dropdown, initialSelection) ->
    selectedItem = null

    # We have to match based off text, not ID
    for uid, item of dropdown.instance.items
      selectedItem = item if item.text == initialSelection

    dropdown.select(selectedItem) if selectedItem


  # @param {jQuery} $menu - the jQuery Dropdown UI element
  addCallbacks: ($menu) ->
    $decodeHtmlEntities = $('<div/>')

    $menu.on 'dropdown-after-select', (_, item) =>
      id = window.$housing_labels.findIndex (currentValue, i, array)->
        currentValue == item

      @$select.val(id)
      @$select.trigger('change')
      @$select.trigger('change:housing_type', @typeFromId(id))
      @$select.trigger('change:housing_facility', @facilityName(item))


  itemId: (item) ->
    for id in @facilityUnitIds(item)
      return id if @labels[id] == item.text


  facilityUnitIds: (item) ->
    ancestors = @itemAncestors(item)
    @hierarchy[ancestors[0].text][ancestors[1].text]


  itemAncestors: (item) ->
    ancestors = [item]
    while item.parent
      parent = @widget().getItem(item.parent)
      ancestors.unshift parent
      item = parent

    ancestors


  # @return {String} The Housing Type of the Facility that the given HousingUnit
  #   ID belongs to.
  typeFromId: (id) ->
    id = parseInt(id, 10)
    for type, facilities of @hierarchy
      for _, ids of facilities
        return type.toLowerCase() if $.inArray(id, ids) != -1
    null


  # @return {String} The name of the Facility that the given menu item belongs
  #   to.
  facilityName: (item) ->
    ancestors = @itemAncestors(item)
    ancestors[ancestors.length - 2].text


  addDurationCallbacks: ->
    @addSingleDurationCallback('arrived_at', 'Person Arrives:')
    @addSingleDurationCallback('departed_at', 'Person Departs:')


  addSingleDurationCallback: (type, hintPrefix) ->
    $container = @$select.closest('fieldset')
    $target = $container.find("input[name$='[#{type}]']")
    return unless $target.length

    $hint = $('<p class="inline-hints" />').insertAfter($target)
    update = ->
      date = $(this).val()
      $target.val(date) unless $target.val().length
      $hint.text("#{hintPrefix} #{date}")

    $inputs = $("input[name='attendee[#{type}]'], input[name='child[#{type}]']")
    $inputs.on('change', update)
    $inputs.each(update)
