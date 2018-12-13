# frozen_string_literal: true

class CreateJoinTableMissionProductor < ActiveRecord::Migration[5.2]
  def change
    create_join_table :missions, :productors do |t|
      # t.index [:mission_id, :productor_id]
      # t.index [:productor_id, :mission_id]
    end
  end
end
