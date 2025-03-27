/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// The list of possible Ministry codes that the user may choose from are
// actually organized logically in a three-tier hiearchy. This code replaces the
// flat <select> element with a UI element that lets the user "drill down" from
// the top tier, through the second tier, to their final choice in the third
// tier.
$(function() {
  const $select = $('[data-ministry-code]');
  const hierarchy = $select.data('hierarchy');
  const labels = $select.data('labels');

  if (!$select.length || !hierarchy || !labels) { return; }

  const widget = new DataMinistrySelectWidget($select, hierarchy, labels);
  return widget.replaceCodeSelectWithMultiLevelSelect();
});


class DataMinistrySelectWidget {
  // @param {JQuery} $select - The element to control with this widget.
  // @param {Object.<number, Object>} hierarchy - A tree where each key is a
  //   Ministry's DB ID and each value is an object containing a sub-tree. A
  //   Ministry's sub-tree represents all the others ministries in its
  //   organisation.
  // @param {Object.<number, string>} labels - A map of Ministry DB IDs to their
  //   name.
  constructor($select, hierarchy, labels) {
    this.$select = $select;
    this.hierarchy = hierarchy;
    this.labels = labels;
    this.labelIdMap = this._swapKeysWithValues(this.labels);
  }


  // @return {Object} An object withe the keys and values swapped.
  _swapKeysWithValues(obj) {
    const newObj = {};
    for (var k in obj) {
      var v = obj[k];
      if (obj.hasOwnProperty(k)) { newObj[v] = k; }
    }
    return newObj;
  }


  // Creates the UI widget and replaces the HTML select element with it
  replaceCodeSelectWithMultiLevelSelect() {
    this.hideSelector();

    const $menu = this.createMutliLevelSelect();
    this.$select.after($menu);

    const $widget = this.setupDropdownPlugin($menu, this.labels[this.$select.val()]);

    const allowDeselect = !!this.$select.find('option[value=""]').length;
    if (allowDeselect) {
      const $close = $('<abbr class="dropdown__close">');
      $widget.append($close);
      this.createCloseCallback($close, $menu);
    }

    return this.createSelectCallback($menu);
  }


  // Hides the original selector. The new UI element will change it's value, so
  // it will continue to exist, but remain hidden.
  // The jQuery "Chosen" UI is likely handling the "flat selector". We are taking
  // over this role, so remove it
  hideSelector() {
    this.$select.chosen('destroy');
    return this.$select.css('display', 'none');
  }


  // Creates the hierarchy of <ul> elements that the jQuery Dropdown plugin uses
  // as its input.
  createMutliLevelSelect() {
    return this.createSublist($('<ul>'), this.hierarchy);
  }


  // @param {jQuery} $list - a <ul> element to add the new sub-list to
  // @param {Object} items - an object descibing a hiearchy of menu items. Each
  //   key represents a ministry code. Each key is either: a) an array of
  //   strings, representing the contents of the sub-menu, or, b) an object
  //   representing another nested sub-menu
  createSublist($list, items) {
    for (var id in items) {
      var subListItems = items[id];
      var $selectParentItem = $('<li>').text(this.labels[id]);

      var $listItem =
        (() => {
        if ($.isEmptyObject(subListItems)) {
          return $selectParentItem;
        } else {
          const $subList =
            this.createSublist($('<ul>'), subListItems).prepend($selectParentItem);
          return $(`<li data-dropdown-text='${this.labels[id]}'>`).append($subList);
        }
      })();

      $list.append($listItem);
    }

    return $list;
  }


  setupDropdownPlugin($menu, initialSelection) {
    $menu.on('dropdown-init', (_, dropdown) => {
      return this.setDefaultSelection(dropdown, initialSelection);
    });
    $menu.dropdown();

    return this.$select.siblings('.dropdown');
  }


  setDefaultSelection(dropdown, initialSelection) {
    let selectedItem = null;

    // We have to match based off text, not ID
    const $decodeHtmlEntities = $('<div/>');
    for (var uid in dropdown.instance.items) {
      var item = dropdown.instance.items[uid];
      var itemText =  $decodeHtmlEntities.html(item.text).text();
      if (itemText === initialSelection) { selectedItem = item; }
    }

    if (selectedItem) { return dropdown.select(selectedItem); }
  }


  // @param {jQuery} $menu - the jQuery Dropdown UI element
  createSelectCallback($menu) {
    const $decodeHtmlEntities = $('<div/>');

    return $menu.on('dropdown-after-select', (_, item) => {
      const text = $decodeHtmlEntities.html(item.text).text();
      this.$select.val(this.labelIdMap[text]);
      return this.$select.trigger('change');
    });
  }


  createCloseCallback($close, $menu) {
    $close.on('click', () => {
      const plugin = $menu.data('dw.plugin.dropdown');
      plugin.selectValue(null, true);
      plugin.toggleText('');
      this.$select.val(null);
      return this.$select.trigger('change');
    });

    const showHide = () => {
      if (this.$select.val()) {
        return $close.removeClass('dropdown__close--hide');
      } else {
        return $close.addClass('dropdown__close--hide');
      }
    };

    this.$select.on('change', showHide);
    return showHide();
  }
}
