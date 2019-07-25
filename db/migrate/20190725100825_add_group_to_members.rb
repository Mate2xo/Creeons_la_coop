# frozen_string_literal: true

class AddGroupToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :group, :string, default: nil
  end
end
