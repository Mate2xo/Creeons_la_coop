class ChangeStartTimeAndEndTimeToBeDatetimeInEnrollments < ActiveRecord::Migration[5.2]
  def up
    change_table :enrollments, bulk: true do |t|
      t.rename :start_time, :old_start_time
      t.rename :end_time, :old_end_time
      t.column :start_time, :datetime
      t.column :end_time, :datetime
    end
  end

  def down
    change_table :enrollments, bulk: true do |t|
      t.remove :start_time
      t.remove :end_time
      t.rename :old_start_time, :start_time
      t.rename :old_end_time, :end_time
    end
  end
end
