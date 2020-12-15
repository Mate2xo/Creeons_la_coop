class RemoveHourAndMinuteFromStaticSlots < ActiveRecord::Migration[5.2]
  def change
    remove_column :static_slots, :hour, :integer
    remove_column :static_slots, :minute, :integer
  end
end
