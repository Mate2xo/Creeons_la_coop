# frozen_string_literal: true

class AddModeratorToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :moderator, :boolean, default: false
  end
end
