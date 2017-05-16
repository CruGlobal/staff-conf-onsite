class Stay::IndexCell < ::IndexCell
  def show
    @family = Family.includes(:attendees).find_by(id: params[:family_id]) if params[:family_id]


    if @family
      @family.attendees.each do |attendee|
        form_for attendee do |f|
          person_cell(f, attendee).call(:stay_subform)
        end
      end
    end
  end

  private
  def person_cell(form, attendee)
    @person_cell ||= cell('person/form', form, person: attendee)
  end

  def dom_class(record_or_class, prefix = nil)
    'attendee_form'
  end

  def dom_id(record_or_class, prefix = nil)
    "attendee_form_#{record_or_class.id}"
  end
end
