class CreateMissionSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :mission_slots do |t|
      t.datetime :start_time
      t.belongs_to :mission, foreign_key: true

      t.timestamps
    end
  end
end
