# frozen_string_literal: true

class AddPrimaryKeyAndTimeSlotsToMembersMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :members_missions, :id, :primary_key
    add_column :members_missions, :start_time, :time
    add_column :members_missions, :end_time, :time
    add_index :members_missions, :mission_id
  end
end
