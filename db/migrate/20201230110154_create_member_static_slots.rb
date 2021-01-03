class CreateMemberStaticSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :member_static_slots do |t|
      t.references :static_slot, foreign_key: true
      t.references :member, foreign_key: true

      t.timestamps
    end
  end
end
