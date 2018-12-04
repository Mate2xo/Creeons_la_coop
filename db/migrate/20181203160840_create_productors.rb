class CreateProductors < ActiveRecord::Migration[5.2]
  def change
    create_table :productors do |t|
      t.string :name
      t.text :description
      t.string :phone_number
      t.timestamps
    end
  end
end
