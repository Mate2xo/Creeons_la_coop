class CreateGroupMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_members do |t|
      t.belongs_to :group, foreign_key: true
      t.belongs_to :member, foreign_key: true

      t.timestamps
    end
  end
end
