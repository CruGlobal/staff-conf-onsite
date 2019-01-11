class CreateChildcareEnvelopes < ActiveRecord::Migration
  def change
    create_table :childcare_envelopes do |t|
      t.string :envelope_id, index: true, null: false
      t.string :status, null: false

      t.timestamps null: false
    end
    add_column :childcare_envelopes, :recipient_id, :integer, null: false
    add_foreign_key :childcare_envelopes, :people, column: :recipient_id
    add_column :childcare_envelopes, :child_id, :integer, null: false
    add_foreign_key :childcare_envelopes, :people, column: :child_id
  end
end
