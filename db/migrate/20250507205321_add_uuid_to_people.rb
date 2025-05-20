class AddUuidToPeople < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    add_column :people, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :people, :uuid, unique: true
  end
end
