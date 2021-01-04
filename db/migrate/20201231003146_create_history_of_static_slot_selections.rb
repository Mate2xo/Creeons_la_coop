class CreateHistoryOfStaticSlotSelections < ActiveRecord::Migration[5.2]
  def change
    create_table :history_of_static_slot_selections do |t|
      t.references :member
      t.references :static_slot

      t.timestamps
    end
  end
end
