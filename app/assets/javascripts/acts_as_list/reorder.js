/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const createPositionSelectors = function() {
  const page = query_param('page') || 1;
  const perPage = query_param('per_page') || 30;
  const lastIndex = indexRecordsCount();

  return createSelectors(positionOptions(lastIndex));
};


var positionOptions = lastIndex => __range__(1, lastIndex, true).map((position) => ({value: position, name: ordinal(position)}));


var createSelectors = options => $('.index_table tbody tr').each(function() {
  const path = updatePath($(this).find('a.view_link').attr('href'));
  const $positionCell = $(this).find('.col-position');

  const position = parseInt($positionCell.text(), 10);
  const $selector = createSingleSelector(position, options, path);

  return $positionCell.empty().append($selector);
});


var updatePath = root_path => `${root_path}/reposition`;


var createSingleSelector = function(index, options, path) {
  const $select = $('<select>').append(createOptions(options, index));

  return $select.on('change', () => $.ajax({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    url: path,
    type: 'PATCH',
    data: {
      position: $select.val()
    }
  })
    .done(() => window.location.reload(true)));
};


var createOptions = (options, selected) => (() => {
  const result = [];
  for (var opt of Array.from(options)) {
    var $option = $('<option>').attr('value', opt['value']).text(opt['name']);
    result.push($option.prop('selected', selected === opt['value']));
  }
  return result;
})();


pageAction('childcares', 'index', createPositionSelectors);
pageAction('conferences', 'index', createPositionSelectors);
pageAction('courses', 'index', createPositionSelectors);
pageAction('housing_facilities', 'index', createPositionSelectors);

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}