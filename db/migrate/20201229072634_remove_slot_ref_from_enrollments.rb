class RemoveSlotRefFromEnrollments < ActiveRecord::Migration[5.2]
  def change
    remove_reference :enrollments, :mission_slot, foreign_key: false
  end
end
