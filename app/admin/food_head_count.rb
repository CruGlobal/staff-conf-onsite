ActiveAdmin.register_page 'Food Head Count' do
  content do
    head_count =
      FoodHeadCount::CreateTable.call(
        params.permit(:cafeteria, :start_at, :end_at)
      )

    panel 'Daily Meals' do
      render 'table', date_counts: head_count.table
    end
  end

  sidebar 'Filters' do
    render 'filter_form'
  end
end
