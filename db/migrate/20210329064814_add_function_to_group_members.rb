class AddFunctionToGroupMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_members, :function, :text
  end
end
