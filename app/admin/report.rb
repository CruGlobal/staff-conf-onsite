ActiveAdmin.register Report do
  partial_view :index, :show
  permit_params :category, :name, :query, :role

  filter :category
  filter :name

  member_action :download, method: :get do
    report = Report.find(params[:id])
    send_data(report.to_csv, filename: "#{report.name}-#{Date.today}.csv")
  end
end
