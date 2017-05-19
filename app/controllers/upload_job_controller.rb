class UploadJobController < ApplicationController
  def show
    return head :forbidden unless current_user.present?

    render json: current_user.upload_jobs.find(params[:id])
  end
end
