class RemoveGroupManagerMailFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :group_manager_mail, :string
  end
end
