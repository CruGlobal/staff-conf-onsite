/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
$(function() {
  if (!($('.show.children').length > 0)) { return; }

  $('#void_button').click(() => confirm(`When voiding a sent DocuSign envelope, the \
recipient will not be able to access or sign the \
document anymore, and they will receive an automated \
email from DocuSign notifying them that the envelope \
has been voided. \
\n\nAfter successfully voiding an envelope, you will \
be able to send a new envelope.`
  ));

  $('.send_docusign_button').click(() => confirm("Are you sure you want to send this recipient a DocuSign envelope?"));

  return $('.create_new_docusign_button').click(() => confirm(`Are you sure you want to send a new docusign \
envelope to the recipient? \
\n\nThe existing envelope can not be voided as it \
was already signed by the recipient.`
  ));
});
