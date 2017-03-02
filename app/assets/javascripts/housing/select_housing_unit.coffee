$ ->
  $('body').on 'DOMNodeInserted', (event) ->
    $select = $(event.target).find('[data-housing_unit-id]')
    setupHousingUnitSelectWidth($select) if $select.length

  $('[data-housing_unit-id]').each -> setupHousingUnitSelectWidth($(this))


setupHousingUnitSelectWidth = ($select) ->
  hierarchy = $select.data('hierarchy')
  labels = $select.data('labels')

  return unless $select.length && hierarchy && labels

  widget = new HousingUnitSelectWidget($select, hierarchy, labels)
  widget.replaceCodeSelectWithMultiLevelSelect()
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
  constructor: (@$select, @hierarchy, @labels) ->
    @labelIdMap = @swapKeysWithValues(@labels)


  # @return {Object} An object withe the keys and values swapped.
  swapKeysWithValues: (obj) ->
    newObj = {}
    for k, v of obj
      newObj[v] = k if obj.hasOwnProperty(k)
    newObj


  # Creates the UI widget and replaces the HTML select element with it
  replaceCodeSelectWithMultiLevelSelect: ->
    @hideSelector()

    $menu = @createMutliLevelSelect()
    @$select.after($menu)

    @setupDropdownPlugin($menu, @labels[@$select.val()])
    @addCallbacks($menu)

    $menu.select(
      $menu.data('dw.plugin.dropdown').selected()
    )


  # Hides the select element that this UI widget will control.
  hideSelector: ->
    @$select.chosen('destroy')
    @$select.css('display', 'none')


  # Creates the HTML list eelement that the jQuery Dropdown plugin takes as its
  # input.
  createMutliLevelSelect: ->
    $list = $('<ul>')

    for type, facilities of @hierarchy
      if $.isEmptyObject(facilities)
        $typeItem = $("<li>").text(type).appendTo($list)
      else
        $typeItem = $("<li data-dropdown-text='#{type}'>").appendTo($list)
        $subList = $('<ul>').appendTo($typeItem)

        for facilityName, unitIds of facilities
          $facilityItem =
            $("<li data-dropdown-text='#{facilityName}'>").appendTo($subList)
          $unitList = $('<ul>').appendTo($facilityItem)

          for id in unitIds
            $('<li>').text(@labels[id]).appendTo($unitList)

    $list


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
      id = @labelIdMap[$decodeHtmlEntities.html(item.text).text()]

      @$select.val(id)

      @$select.trigger('change')
      @$select.trigger('change:housing_type', @typeFromId(id))
      @$select.trigger('change:housing_facility', @facilityNameFromId(id))


  # @return {String} The Housing Type of the Facility that the given HousingUnit
  #   ID belongs to.
  typeFromId: (id) ->
    id = parseInt(id, 10)
    for type, facilities of @hierarchy
      for _, ids of facilities
        return type.toLowerCase() if $.inArray(id, ids) != -1
    null


  # @return {String} The name of the Facility that the given HousingUnit ID
  #   belongs to.
  facilityNameFromId: (id) ->
    id = parseInt(id, 10)
    for _, facilities of @hierarchy
      for facilityName, ids of facilities
        return facilityName if $.inArray(id, ids) != -1
    null


  addDurationCallbacks: ->
    @addSingleDurationCallback('arrived_at', 'Person Arrives:')
    @addSingleDurationCallback('departed_at', 'Person Departs:')


  addSingleDurationCallback: (type, hintPrefix) ->
    $container = @$select.closest('fieldset')
    $target = $container.find("input[name$='[#{type}]']")
    return unless $target.length

    $hint = $('<p class="inline-hints" />').insertAfter($target)
    update = -> $hint.text("#{hintPrefix} #{$(this).val()}")

    $inputs = $("input[name='attendee[#{type}]'], input[name='child[#{type}]']")
    $inputs.on('change', update)
    $inputs.each(update)
