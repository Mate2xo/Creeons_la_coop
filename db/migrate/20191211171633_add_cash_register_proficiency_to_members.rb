# frozen_string_literal: true

class AddCashRegisterProficiencyToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :cash_register_proficiency, :integer, default: 0
  end
end
