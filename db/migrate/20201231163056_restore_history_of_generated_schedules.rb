class RestoreHistoryOfGeneratedSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :history_of_generated_schedules do |t|
      t.datetime :month_number

      t.timestamps
    end
  end
end
