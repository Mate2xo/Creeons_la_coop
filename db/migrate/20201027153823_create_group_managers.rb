class CreateGroupManagers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_managers do |t|
      t.belongs_to :managed_group, foreign_key: { to_table: :groups }
      t.belongs_to :manager, foreign_key: { to_table: :members }

      t.timestamps
    end
  end
end
