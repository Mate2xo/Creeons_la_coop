# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :postal_code
      t.string :city
      t.string :street_name_1
      t.string :street_name_2
      t.timestamps
    end
  end
end
