# The list of possible Ministry codes that the user may choose from are
# actually organized logically in a three-tier hiearchy. This code replaces the
# flat <select> element with a UI element that lets the user "drill down" from
# the top tier, through the second tier, to their final choice in the third
# tier.
$ ->
  $select = $('[data-ministry-code]')
  hierarchy = $select.data('hierarchy')
  labels = $select.data('labels')

  return unless $select.length && hierarchy && labels

  widget = new DataMinistrySelectWidget($select, hierarchy, labels)
  widget.replaceCodeSelectWithMultiLevelSelect()


class DataMinistrySelectWidget
  # @param {JQuery} - The element to control with this widget.
  # @param {Object.<number, Object>} hierarchy - A tree where each key is a
  #   Ministry's DB ID and each value is an object containing a sub-tree. A
  #   Ministry's sub-tree regresents all the others ministries in its
  #   organisation.
  # @param {Object.<number, string>} labels - A map of Ministry DB IDs to their
  #   name.
  constructor: (@$select, @hierarchy, @labels) ->
    @labelIdMap = @_swapKeysWithValues(@labels)


  _swapKeysWithValues: (obj) ->
    newObj = {}
    for k, v of obj
      newObj[v] = k if obj.hasOwnProperty(k)
    newObj


  replaceCodeSelectWithMultiLevelSelect: ->
    @hideSelector()

    $menu = @createMutliLevelSelect()
    @$select.after($menu)

    @setupDropdownPlugin($menu, @labels[@$select.val()])
    @addCallbacks($menu)


  # Hides the original selector. The new UI element will change it's value, so it
  # will continue to exist, but remain hidden.
  # The jQuery "Chosen" UI is likely handling the "flat selector". We are taking
  # over this role, so remove it
  hideSelector: ->
    @$select.chosen('destroy')
    @$select.css('display', 'none')


  # Creates the hierarchy of <ul> elements that the jQuery Dropdown plugin uses
  # as its input.
  createMutliLevelSelect: ->
    @createSublist($('<ul>'), @hierarchy)


  # @param {jQuery} $list - a <ul> element to add the new sub-list to
  # @param {Object} items - an object descibing a hiearchy of menu items. Each
  #   key represents a ministry code. Each key is either: a) an array of
  #   strings, representing the contents of the sub-menu, or, b) an object
  #   representing another nested sub-menu
  createSublist: ($list, items) ->
    for id, subListItems of items
      $selectParentItem = $('<li>').text(@labels[id])

      $listItem =
        if $.isEmptyObject(subListItems)
          $selectParentItem
        else
          $subList =
            @createSublist($('<ul>'), subListItems).prepend($selectParentItem)
          $("<li data-dropdown-text='#{@labels[id]}'>").append($subList)

      $list.append($listItem)

    $list


  setupDropdownPlugin: ($menu, initialSelection) ->
    $menu.on 'dropdown-init', (_, dropdown) =>
      @setDefaultSelection(dropdown, initialSelection)
    $menu.dropdown()


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
      text = $decodeHtmlEntities.html(item.text).text()
      @$select.val(@labelIdMap[text])
      @$select.trigger('change')