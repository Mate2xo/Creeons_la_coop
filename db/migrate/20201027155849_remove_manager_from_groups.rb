class RemoveManagerFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_reference :groups, :manager, foreign_key: { to_table: :members }
  end
end
