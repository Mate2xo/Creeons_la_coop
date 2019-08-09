# frozen_string_literal: true

class AddCoordinatesToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :coordinates, :float, array: true
  end
end
