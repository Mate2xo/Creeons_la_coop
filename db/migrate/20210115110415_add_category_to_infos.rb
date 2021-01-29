class AddCategoryToInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :infos, :category, :string
  end
end
