class DropHistoryOfGeneratedSchedules < ActiveRecord::Migration[5.2]
  def up
    drop_table :history_of_generated_schedules
  end

  def down
    create_table :history_of_generated_schedules do |t|
      t.datetime :month_number

      t.timestamps
    end
  end
end
