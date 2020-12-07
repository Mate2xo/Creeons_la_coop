class AddMemberRefToSlots < ActiveRecord::Migration[5.2]
  def change
    add_reference :mission_slots, :member, foreign_key: true
  end
end
