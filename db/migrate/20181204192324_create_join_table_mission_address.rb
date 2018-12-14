# frozen_string_literal: true

class CreateJoinTableMissionAddress < ActiveRecord::Migration[5.2]
  def change
    create_join_table :missions, :addresses do |t|
      # t.index [:mission_id, :address_id]
      # t.index [:address_id, :mission_id]
    end
  end
end
