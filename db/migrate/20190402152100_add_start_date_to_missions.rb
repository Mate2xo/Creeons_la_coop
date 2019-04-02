# frozen_string_literal: true

class AddStartDateToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :start_date, :datetime
  end
end
