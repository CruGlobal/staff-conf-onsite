class FixReportsTablePkeySequence < ActiveRecord::Migration
  def up
    execute "SELECT SETVAL('ministries_id_seq', (SELECT MAX(id) FROM ministries));" 
  end

  def down
  end
end
