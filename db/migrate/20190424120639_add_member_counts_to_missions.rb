# frozen_string_literal: true

class AddMemberCountsToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :max_member_count, :integer
    add_column :missions, :min_member_count, :integer
  end
end
