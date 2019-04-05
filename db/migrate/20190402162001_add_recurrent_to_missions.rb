# frozen_string_literal: true

class AddRecurrentToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :recurrent, :boolean
  end
end
