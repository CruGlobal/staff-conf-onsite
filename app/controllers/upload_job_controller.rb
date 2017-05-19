class UploadJobController < ApplicationController
  def show
    render json: UploadJob.find(params[:id])
  end
end
