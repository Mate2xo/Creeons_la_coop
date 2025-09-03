# frozen_string_literal: true

# Automatic generation of scheduled Missions is not needed anymore,
# as admins actually use the more flexible RecurrentMissions from the missions form.
class DropDefinitivelyHistoryOfGeneratedSchedules < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up { drop_table :history_of_generated_schedules }
      dir.down do
        create_table :history_of_generated_schedules do |t|
          t.datetime :month_number
          t.timestamps
        end
      end
    end
  end
end
