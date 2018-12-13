# frozen_string_literal: true

class AddCoordonneeToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :coordonnee, :string
  end
end
