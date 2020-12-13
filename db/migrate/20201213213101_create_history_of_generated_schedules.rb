class CreateHistoryOfGeneratedSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :history_of_generated_schedules do |t|
      t.datetime :month_of_generated_schedule

      t.timestamps
    end
  end
end
