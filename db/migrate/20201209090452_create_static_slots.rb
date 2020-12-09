class CreateStaticSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :static_slots do |t|
      t.integer :week_day, null: false
      t.integer :hour, null: false
      t.integer :minute, null: false
      t.integer :week_type, null: false

      t.timestamps
    end
  end
end
