$ ->
  return unless $('.show.children').length > 0

  $('#void_button').click ->
    confirm "
    Only pending envelopes are voidable via this page.
    \n\nWhen voiding a sent DocuSign envelope, the
    recipient will not be able to access or sign the
    document anymore, and they will receive an automated
    email from DocuSign notifying them that the envelope
    has been voided.
    \n\nAfter successfully voiding an envelope, you will
    be able to send a new envelope."

  $('.send_docusign_button').click ->
    confirm "Are you sure you want to send this recipient a DocuSign envelope?"
