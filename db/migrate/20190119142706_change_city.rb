# frozen_string_literal: true

class ChangeCity < ActiveRecord::Migration[5.2]
  def change
    change_column_null :addresses, :city, false
  end
end
