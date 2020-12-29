class DropStaticSlots < ActiveRecord::Migration[5.2]
  def up
    drop_table :static_slots
  end

  def down
    create_table :static_slots do |t|
      t.integer :week_day, null: false
      t.integer :week_type, null: false
      t.datetime :start_time

      t.timestamps
    end
  end
end
