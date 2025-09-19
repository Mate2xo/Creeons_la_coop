# frozen_string_literal: true

# Sync new lower enum value with default
class ChangeCashRegisterProficiencyDefaultOnMembers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :members, :cash_register_proficiency, from: 0, to: 1
  end
end
