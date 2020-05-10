# frozen_string_literal: true

# Members are registered at the shop's cash register,
# and can share this Id whith their family
class AddRegisterIdToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :register_id, :integer
  end
end
