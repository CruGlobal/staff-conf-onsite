class UploadJobController < ApplicationController
  def show
    render json: current_user.upload_jobs.find(params[:id])
  end
end
