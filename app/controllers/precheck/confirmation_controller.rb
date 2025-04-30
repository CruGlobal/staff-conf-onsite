class Precheck::ConfirmationController < PrecheckController
  def create
    redirect_to precheck_status_path and return unless Precheck::EligibilityService.new(family: @family).call

    hotel = params['hotel'] == 'Other' ? " OTHER - #{params['other_hotel']} " : params['hotel']
    HotelStay.create(hotel: hotel, family_id: @family.id)
 
    @family.update!(precheck_status: :approved)
    Precheck::UpdatedFamilyStatusService.new(family: @family).call
  end
end
