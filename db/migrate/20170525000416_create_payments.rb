class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :family,   null: false, index: true
      t.integer :price_cents, null: false
      t.integer :cost_type,   null: false, index: true
      t.string :business_unit
      t.string :operating_unit
      t.string :department_id
      t.string :project_id
      t.string :reference

      t.timestamps null: false
    end
  end
end
