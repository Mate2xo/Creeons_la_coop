class RestoreStaticSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :static_slots do |t|
      t.integer :week_day, null: false
      t.datetime :start_time, null: false
      t.integer :week_type, null: false

      t.timestamps
    end
  end
end
