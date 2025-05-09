class ExternalFormsController < ApiBaseController
  before_action :validate_api_key  

  def approve
    handle_form_update(
      uid: approve_params[:uid],
      approval_state: true,
      approved_by: 'external_api',
      success_message: 'Form approved successfully.',
      action: 'approved'
    )
  end

  def disapprove
    handle_form_update(
      uid: disapprove_params[:uid],
      approval_state: false,
      approved_by: nil,
      success_message: 'Form disapproved successfully.',
      action: 'disapproved'
    )
  end

  private

  def validate_api_key
    expected_api_key = Rails.application.credentials.external_api_key || ENV['EXTERNAL_API_KEY']
    provided_api_key = request.query_parameters['apiKey']

    unless ActiveSupport::SecurityUtils.secure_compare(provided_api_key.to_s, expected_api_key.to_s)
      Rails.logger.warn(unauthorized_access_log(provided_api_key))
      render json: { error: 'Unauthorized: Invalid or missing API key' }, status: :forbidden
    end
  end

  def approve_params
    params.permit(:uid)
  end

  def disapprove_params
    params.permit(:uid)
  end

  def handle_form_update(uid:, approval_state:, approved_by:, success_message:, action:)
    child = Child.find_by(uuid: uid)

    unless child
      Rails.logger.warn(child_not_found_log(uid))
      return render json: { error: 'Child not found' }, status: :not_found
    end

    if child.update(forms_approved: approval_state, forms_approved_by: approved_by)
      Rails.logger.info(success_log(child, uid, action))
      render json: { message: success_message }
    else
      Rails.logger.error(failure_log(child, uid, action))
      render json: { error: 'Unable to process form. Please try again later.' }, status: :unprocessable_entity
    end
  end

  # Log message helpers

  def child_not_found_log(uid)
    "[ExternalFormsController] UID not found: #{uid}, IP: #{request.remote_ip}"
  end

  def unauthorized_access_log(provided_api_key)
    "[ExternalFormsController] Unauthorized access attempt. " \
    "IP: #{request.remote_ip}, Provided Key: #{provided_api_key.inspect}"
  end

  def success_log(child, uid, action)
    "[ExternalFormsController] Form #{action} for child #{child.id} (#{uid}) " \
    "by external API. IP: #{request.remote_ip}"
  end

  def failure_log(child, uid, action)
    errors = child.errors.full_messages.join(', ')
    "[ExternalFormsController] Failed to #{action} form for child #{child.id} (#{uid}). " \
    "Errors: #{errors}. IP: #{request.remote_ip}"
  end
end
