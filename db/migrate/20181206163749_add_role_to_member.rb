# frozen_string_literal: true

class AddRoleToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :role, :string, default: "user"
  end
end
