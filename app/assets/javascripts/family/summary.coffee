$ ->
  $('.summary span.title').each ->
    span = $(this)
    if span.data('type') == 'Child'
      url = '/children/'
    else
      url = '/attendees/'
    url += span.data('id')
    link = '<a href="' + url + '">' + span.html() + '</a>'
    span.replaceWith(link)