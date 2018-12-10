class AddAuthorRefToMissions < ActiveRecord::Migration[5.2]
  def change
    add_reference :missions, :author, foreign_key: {to_table: :members}
  end
end
