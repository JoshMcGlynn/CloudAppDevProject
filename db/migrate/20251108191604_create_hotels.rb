class CreateHotels < ActiveRecord::Migration[8.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :location
      t.integer :rating
      t.text :description

      t.timestamps
    end
  end
end
