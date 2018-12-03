class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :email
      t.string :phone_number
      t.text :biography

      t.timestamps
    end
  end
end
