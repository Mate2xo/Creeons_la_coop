# frozen_string_literal: true

class RemoveCoordonneeFromAddresses < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :coordonnee, :string
  end
end
