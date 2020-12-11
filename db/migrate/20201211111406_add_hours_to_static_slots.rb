class AddHoursToStaticSlots < ActiveRecord::Migration[5.2]
  def change
    add_column :static_slots, :hours, :datetime
  end
end
