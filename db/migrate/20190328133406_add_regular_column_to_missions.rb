# frozen_string_literal: true

class AddRegularColumnToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :regular, :boolean
  end
end
