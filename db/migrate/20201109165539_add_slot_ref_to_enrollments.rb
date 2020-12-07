class AddSlotRefToEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_reference :enrollments, :mission_slot, foreign_key: true
  end
end
