# frozen_string_literal: true

class AddProductorRefToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :productor, foreign_key: true
  end
end
