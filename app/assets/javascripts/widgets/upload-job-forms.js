/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const POLLING_TIME = 1000;

// $ ->
//   $('form.upload-job-js').each ->
//     $form = $(this)

//     $form.on 'submit', replaceSubmitButtons
//     ajaxForm($form)


// Replace the form's submit buttons, to avoid a double-submit.
const replaceSubmitButtons = function() {
  return $(this).find('fieldset.actions > ol').replaceWith(
    $('<ol>').append(
      $('<li class="cancel">').append(
        $('<a>').attr('href', window.location.href).text('New Upload Form')
      )
    )
  );
};


// Use jQuery.form plugin to submit form via AJAX.
const ajaxForm = function($form) {
  const options = {
    dataType: 'json',
    success: startPolling
  };

  return $form.ajaxForm(options);
};


// Start polling the server for updates
var startPolling = function(data, textStatus, jqXHR, $form) {
  const poller = new UploadJobPoller($form, data.id, data);
  return poller.startPolling();
};


class UploadJobPoller {
  constructor($form, id, data) {
    this.$form = $form;
    this.id = id;
    this.createStatusContainer();
    this.updateStatus(data);
    this.currentStage = null;
  }


  // Poll continuously until the job is done
  startPolling() { return this.poll(true); }


  poll(repeat) {
    return $.getJSON(this.job_url()).done(data => {
      this.updateStatus(data);
      if (repeat && !this.finished) { return setTimeout((() => this.poll(true)), POLLING_TIME); }
    });
  }


  job_url() { return `/upload_job/${this.id}`; }


  updateStatus(data) {
    const stageChanged = this.stage !== data.stage;
    if (stageChanged) { this.createNewCurrentStage(data.stage); }
    this.stage = data.stage;

    this.finished = data.finished;
    this.success = data.success;
    this.percentage = data.percentage;

    this.message = data.html_message;
    if (this.finished && !this.message) { this.message = 'Finished Import!'; }

    this.updateStatusMessage();
    if (this.currentStage) { return this.currentStage.update(this.finished, this.success, this.percentage); }
  }


  updateStatusMessage() {
    this.$jobMessage.html(this.message);
    return this.setJobMessageStyle();
  }


  createNewCurrentStage(stage){
    if (stage === 'queued') { return; }

    if (this.currentStage) { this.currentStage.finish(!this.finished || this.success); }
    this.currentStage = new StageStatus(stage);
    return this.$statusContainer.append(this.currentStage.$elem);
  }


  createStatusContainer() {
    const $title = $('<h3>').text('Upload Progress');
    const $note = $('<p class="upload-job__note">').text(
      'You can now leave this page. The import will continue.'
    );

    this.$statusContainer = $('<div class="upload-job__status">');
    this.$jobMessage = $('<div class="upload-job__message">');

    return this.$form.after(
      $('<div class="upload-job">').append($title, $note, this.$statusContainer,
                                           this.$jobMessage)
    );
  }


  setJobMessageStyle() {
    this.$jobMessage.removeClass('flash_notice flash_error');

    if (!(this.message != null ? this.message.length : undefined)) { return; }

    if (this.success) {
      return this.$jobMessage.addClass('flash flash_notice');
    } else {
      return this.$jobMessage.addClass('flash flash_error');
    }
  }
}


class StageStatus {
  constructor(stage) {
    this.stage = stage;
    this.$elem = this.createStatusMessage();
    this.update(false, false, 0);
  }


  createStatusMessage() {
    this.$jobStatus = $('<div class="upload-job__status">').text(this.stage);

    const $progressContainer = $('<div class="upload-job__progress">');
    this.$jobProgress = $('<div class="upload-job__progress-bar">').
                      appendTo($progressContainer);

    return $('<div class="upload-job">').append(this.$jobStatus, $progressContainer,
                                         this.$jobMessage);
  }


  finish(success) { return this.update(true, success, 1); }


  update(finished, success, percentage) {
    this.finished = finished;
    this.success = success;
    this.percentage = percentage;

    return this.updateJobProcessStyle();
  }


  updateJobProcessStyle() {
    if (this.finished) {
      this.$jobProgress.css({width: '100%'});

      if (this.success) {
        return this.$jobProgress.addClass('upload-job__progress-bar--success');
      } else {
        return this.$jobProgress.addClass('upload-job__progress-bar--error');
      }
    } else {
      return this.$jobProgress.css({width: `${this.percentage * 100.0}%`});
    }
  }
}
