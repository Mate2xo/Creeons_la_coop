# frozen_string_literal: true

class RemoveRegularFromMissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :missions, :regular, :boolean
  end
end
