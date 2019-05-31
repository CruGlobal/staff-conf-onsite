class AddRequiredTeamActionToFamily < ActiveRecord::Migration
  def change
    add_column :families, :required_team_action, :string, array: true, default: []
  end
end
