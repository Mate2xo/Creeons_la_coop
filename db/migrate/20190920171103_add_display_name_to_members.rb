# frozen_string_literal: true

class AddDisplayNameToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :display_name, :string
  end
end
