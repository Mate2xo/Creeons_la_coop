class AddGenreToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :genre, :integer, default: 0
  end
end
