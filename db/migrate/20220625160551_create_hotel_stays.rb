class CreateHotelStays < ActiveRecord::Migration
  def change
    create_table :hotel_stays do |t|
      t.text :hotel, :null => false
      t.references :family, index: { unique: true }, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end
