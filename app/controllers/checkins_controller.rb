class CheckinsController < ApplicationController
  layout 'checkin'
  before_action :authenticate_user!
  before_action :require_general_access!
  before_action :set_family, only: %i[confirm_scan create]

  def new
    # Renders the arrival scan form
  end

  def confirm_scan
    if @family
      if @family.arrival_scanned?
        flash.now[:alert] = 'This family has already been marked as arrived.'
        render :new, status: :unprocessable_entity
      else
        @family_names = @family.people.pluck(:first_name, :last_name)
        render :confirm
      end
    else
      flash.now[:alert] = 'Family not found. Please check the Family ID and try again.'
      render :new, status: :unprocessable_entity
    end
  end

  def create
    if @family
      if @family.arrival_scanned?
        flash.now[:alert] = 'This family has already been marked as arrived.'
        render :new, status: :unprocessable_entity
      else
        @family.update(arrival_scanned: true)
        @family_names = @family.people.pluck(:first_name, :last_name)
        render :success
      end
    else
      flash.now[:alert] = 'Family not found. Please check the Family ID and try again.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_general_access!
    unless current_user&.general?
      flash[:alert] = 'Access denied. You must be in the General group to access this page.'
      redirect_to root_path
    end
  end

  def set_family
    @family = Family.find_by(id: params[:family_id])
  end
end 
