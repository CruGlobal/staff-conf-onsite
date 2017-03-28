class Seminary::ShowCell < ::ShowCell
  property :seminary

  def show
    columns do
      column { left_column }
      column { right_column }
    end
  end

  private

  def left_column
    attributes_table do
      row :id
      row :name
      row :code
      row(:course_price) { |s| humanized_money_with_symbol(s.course_price) }
      row :created_at
      row :updated_at
    end
  end

  def right_column
    attendees = seminary.attendees
    panel "Attendees (#{attendees.count})" do
      if attendees.any?
        ul do
          attendees.each do |p|
            li link_to(p.full_name, attendee_path(p))
          end
        end
      else
        strong 'None'
      end
    end
  end
end
