class RenameFunctionToAssignmentInGroupMember < ActiveRecord::Migration[5.2]
  def change
    rename_column :group_members, :function, :assignment
  end
end
