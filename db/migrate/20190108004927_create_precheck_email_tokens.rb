class CreatePrecheckEmailTokens < ActiveRecord::Migration
  def change
    create_table :precheck_email_tokens, id: false do |t|
      t.string :token, index: { unique: true }, null: false
      t.references :family, index: { unique: true }, foreign_key: true, null: false
      t.timestamps
    end
  end
end
