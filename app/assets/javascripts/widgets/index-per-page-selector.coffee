LIMITS = [10, 30, 50, 100, 200, 500, 1000, 5000, 10000, 100000]

# Creates a dropdown selector which allows the user to refresh the page,
# selecting how many records to display on each page
pageAction 'index', ->
  $('.table_tools').append(perPageDropdown())

perPageDropdown = ->
  uri = document.URL
  uri = updateQueryStringParameter(document.URL, 'page', 1)

  $select = $('<select>').append(createOptions({ value: optionsUrl(limit), name: "Records Per Page (#{limit})" } for limit in applicableLimits(), optionsUrl(currentPerPage())))
  $select.on 'change', -> window.location = $select.val() 

  $('<div class="dropdown_menu">').append($select)

optionsUrl = (limit) ->
  uri = document.URL
  uri = updateQueryStringParameter(uri, 'page', 1)
  updateQueryStringParameter(uri, 'per_page', limit)

createOptions = (options, selected) ->
  for opt in options
    $option = $('<option>').attr('value', opt['value']).text(opt['name'])
    $option.prop('selected', selected == opt['value'])

# Returns a subset of LIMITS containing only those numbers less than the total
# number of records
applicableLimits = ->
  count = indexRecordsCount()
  limits = (limit for limit in LIMITS when limit < count)
  limits.push(count)
  limits

updateQueryStringParameter = (uri, key, value) ->
  re = new RegExp("([?&])#{key}=.*?(&|$)", 'i')
  separator = if uri.indexOf('?') != -1 then '&' else '?'

  if uri.match(re)
    uri.replace(re, "$1#{key}=#{value}$2")
  else
    "#{uri}#{separator}#{key}=#{value}"

# Return the current number of items shown
currentPerPage = ->
  initial = Math.min(30, indexRecordsCount())
  parseInt(query_param('per_page') || "#{initial}", 10)
