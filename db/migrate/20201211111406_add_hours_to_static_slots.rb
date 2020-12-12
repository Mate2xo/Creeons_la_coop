class AddHoursToStaticSlots < ActiveRecord::Migration[5.2]
  def change
    add_column :static_slots, :start_time, :datetime
  end
end
