# frozen_string_literal: true

class AddEventToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :event, :boolean, default: false
  end
end
