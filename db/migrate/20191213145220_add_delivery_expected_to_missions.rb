# frozen_string_literal: true

class AddDeliveryExpectedToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :delivery_expected, :boolean, default: false
  end
end
