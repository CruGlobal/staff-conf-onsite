# One of the Housing Preference fields is "confirmed_at" the date at which the
# preferences were confirmed by an admin. Here we replace this input field with
# a toggle button that flips this field between null and today's date.

$ ->
  setupConfirmedAtToggleButton()

setupConfirmedAtToggleButton = () ->
  $input =
    $('form input[name="family[housing_preference_attributes][confirmed_at]"]')
  return unless $input.length

  $btn =
    $('<span class="confirmed_at__toggle">').
      on('click', -> toggleConfirmedAtToggleButton($input, $btn))

  $input.css('display', 'none').after($btn)

  updateConfirmedAtToggleButtonLabel($btn, $input.val())


toggleConfirmedAtToggleButton = ($input, $btn) ->
  value = if $input.val().length then '' else new Date().toISOString()
  $input.val(value)
  updateConfirmedAtToggleButtonLabel($btn, value)


updateConfirmedAtToggleButtonLabel = ($btn, value) ->
  if value.length
    $btn.removeClass('no').addClass('yes').text('confirmed!')
  else
    $btn.removeClass('yes').addClass('no').text('unconfirmed')
