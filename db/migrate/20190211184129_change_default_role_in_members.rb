# frozen_string_literal: true

class ChangeDefaultRoleInMembers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :members, :role, from: "user", to: "member"
  end
end
