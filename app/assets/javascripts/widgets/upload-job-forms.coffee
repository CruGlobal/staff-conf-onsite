POLLING_TIME = 1000

$ ->
  $('form.upload-job-js').each ->
    $form = $(this)

    $form.on 'submit', replaceSubmitButtons
    ajaxForm($form)


# Replace the form's submit buttons, to avoid a double-submit.
replaceSubmitButtons = ->
  $(this).find('fieldset.actions > ol').replaceWith(
    $('<ol>').append(
      $('<li class="cancel">').append(
        $('<a>').attr('href', window.location.href).text('New Upload Form')
      )
    )
  )


# Use jQuery.form plugin to submit form via AJAX.
ajaxForm = ($form) ->
  options =
    dataType: 'json'
    success: startPolling

  $form.ajaxForm options


# Start polling the server for updates
startPolling = (data, textStatus, jqXHR, $form) ->
  poller = new UploadJobPoller($form, data.id, data)
  poller.startPolling()


class UploadJobPoller
  constructor: (@$form, @id, data) ->
    @createStatusMessage()
    @updateStatus(data)


  # Poll continuously until the job is done
  startPolling: -> @poll(true)


  poll: (repeat) ->
    $.getJSON(@job_url()).done (data) =>
      @updateStatus(data)
      setTimeout((=> @poll(true)), POLLING_TIME) if repeat && !@finished


  job_url: -> "/upload_job/#{@id}"


  updateStatus: (data) ->
    @finished = data.finished
    @success = data.success
    @stage = data.stage
    @percentage = data.percentage
    @message = data.html_message

    console.log(data.percentage, data)

    @updateStatusMessage(@stage, @percentage, @message)


  createStatusMessage: ->
    $title = $('<h3>').text('Upload Progress')
    $note = $('<p class="upload-job__note">').text(
      'You can now leave this page. The upload will continue on the server.'
    )

    @$jobStatus = $('<div class="upload-job__status">')
    @$jobMessage = $('<div class="upload-job__message">')

    $progressContainer = $('<div class="upload-job__progress">')
    @$jobProgress = $('<div class="upload-job__progress-bar">').
                      appendTo($progressContainer)

    @$form.after(
      $('<div class="upload-job">').append($title, $note, @$jobStatus,
                                           $progressContainer, @$jobMessage)
    )


  updateStatusMessage: ->
    if @finished
      @$jobStatus.text('Finished.')
    else
      @$jobStatus.text("Current Stage: #{@stage}")

    @updateJobProcessStyle()

    @setJobMessageStyle()
    @$jobMessage.html(@message)


  updateJobProcessStyle: ->
    if @finished
      @$jobProgress.css(width: '100%')

      if @success
        @$jobProgress.addClass('upload-job__progress-bar--success')
      else
        @$jobProgress.addClass('upload-job__progress-bar--error')
    else
      @$jobProgress.css(width: "#{@percentage * 100.0}%")


  setJobMessageStyle: ->
    @$jobMessage.removeClass('flash_notice flash_error')

    return unless @message?.length

    if @success
      @$jobMessage.addClass('flash flash_notice')
    else
      @$jobMessage.addClass('flash flash_error')
