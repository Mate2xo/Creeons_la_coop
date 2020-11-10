class AddManagerReferenceToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :manager, foreign_key: { to_table: :members }
  end
end
