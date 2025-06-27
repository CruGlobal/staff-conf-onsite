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
    family_id = params[:family_id]
    
    if family_id.blank?
      flash.now[:alert] = 'Please enter a Family ID.'
      render :new, status: :unprocessable_entity
      return
    end

    @family = Family.find_by(id: family_id)
    
    if @family.nil?
      flash.now[:alert] = 'Family not found. Please check the Family ID and try again.'
      render :new, status: :unprocessable_entity
      return
    end

    if @family.arrival_scanned?
      flash.now[:alert] = 'This family has already been marked as arrived.'
      render :new, status: :unprocessable_entity
      return
    end

    # Successfully check in the family
    @family.update(arrival_scanned: true, arrival_scanned_at: Time.current)
    @family_names = @family.people.pluck(:first_name, :last_name)
    
    # Render the same form but with success message and family info
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
