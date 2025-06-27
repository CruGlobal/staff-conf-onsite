class CheckinsController < ApplicationController
  layout 'checkin'
  before_action :authenticate_user!
  before_action :require_staff_access!
  

  def new
    # This action now handles both displaying the form and processing check-ins
    if request.post?
      process_checkin
    else
      # Just render the form
      render :new
    end
  end

  private

  def process_checkin
    return render_blank_family_id if family_id_blank?
    return render_family_not_found unless find_family
    return render_already_checked_in if family_already_checked_in?

    check_in_family
    render_success
  end

  def family_id_blank?
    params[:family_id].blank?
  end

  def render_blank_family_id
    flash.now[:alert] = 'Please enter a Family ID.'
    render :new, status: :unprocessable_entity
  end

  def find_family
    @family = Family.find_by(id: params[:family_id])
  end

  def render_family_not_found
    flash.now[:alert] = 'Family not found. Please check the Family ID and try again.'
    render :new, status: :unprocessable_entity
  end

  def family_already_checked_in?
    @family.arrival_scanned?
  end

  def render_already_checked_in
    flash.now[:alert] = 'This family has already been marked as arrived.'
    render :new, status: :unprocessable_entity
  end

  def check_in_family
    @family.update(arrival_scanned: true, arrival_scanned_at: Time.current)
    @family_names = @family.people.pluck(:first_name, :last_name)
  end

  def render_success
    flash.now[:notice] = 'Family successfully checked in!'
    render :new
  end

  def require_staff_access!
    unless current_user&.read_only? || current_user&.general? || current_user&.finance? || current_user&.admin?
      flash[:alert] = 'Access denied. You must be in the staff groups to access this page.'
      redirect_to root_path
    end
  end
end 
