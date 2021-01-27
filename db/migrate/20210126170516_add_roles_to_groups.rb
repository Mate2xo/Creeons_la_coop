class AddRolesToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :roles, :string
  end
end
