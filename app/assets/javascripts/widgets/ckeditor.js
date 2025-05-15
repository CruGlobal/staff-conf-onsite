/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const setupCkeditor = function() {
  return $(this).ckeditor({
    allowedContent: true,

    // Toolbar groups configuration.
    toolbar: [
      {
        name:   'clipboard',
        groups: ['clipboard', 'undo'],
        items:  ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-',
                 'Undo', 'Redo']
      },
      {
        name:  'links',
        items: ['Link', 'Unlink', 'Anchor']
      },
      {
        name:  'insert',
        items: ['Table', 'HorizontalRule', 'SpecialChar']
      },
      {
        name:   'paragraph',
        groups: ['list', 'indent', 'blocks', 'align', 'bidi'],
        items:  ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-',
                 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter',
                 'JustifyRight', 'JustifyBlock']
      },
      '/',
      {
        name:   'styles',
        items: ['Styles', 'Format', 'Font', 'FontSize']
      },
      {
        name:  'colors',
        items: ['TextColor', 'BGColor']
      },
      {
        name:   'basicstyles',
        groups: ['basicstyles', 'cleanup'],
        items:  ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript',
                 'Superscript', '-', 'RemoveFormat', 'Source']
      }
    ],

    toolbar_mini: [
      {
        name:   'paragraph',
        groups: ['list', 'indent', 'blocks', 'align', 'bidi'],
        items:  ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-',
                 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter',
                 'JustifyRight', 'JustifyBlock']
      },
      {
        name:  'styles',
        items: ['Font', 'FontSize'] },
      {
        name:  'colors',
        items: ['TextColor', 'BGColor'] },
      {
        name:   'basicstyles',
        groups: ['basicstyles', 'cleanup'],
        items:  ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript',
                 'Superscript', '-']
      },
      {
        name:  'insert',
        items: ['Image', 'Table', 'HorizontalRule', 'SpecialChar'] }
    ]
  });
};

$(function() {
  function initializeCkeditorOn(node) {
    if (node.nodeType !== 1) return;

    // Handle the node itself if it matches
    if ($(node).is('.ckeditor_input')) {
      setupCkeditor.call(node);
    }

    // Handle any matching descendants
    $(node).find('.ckeditor_input').each(function() {
      setupCkeditor.call(this);
    });
  }

  // Initialize on existing elements
  $('.ckeditor_input').each(function() {
    setupCkeditor.call(this);
  });

  // Watch for future inserts
  const ckeObserver = new MutationObserver(mutations => {
    mutations.forEach(mutation => {
      mutation.addedNodes.forEach(initializeCkeditorOn);
    });
  });

  ckeObserver.observe(document.body, {
    childList: true,
    subtree: true
  });
});
