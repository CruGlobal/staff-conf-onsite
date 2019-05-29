class FixReportsTablePkeySequence < ActiveRecord::Migration
  def up
    execute "SELECT SETVAL('reports_id_seq', (SELECT MAX(id) FROM reports));"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
