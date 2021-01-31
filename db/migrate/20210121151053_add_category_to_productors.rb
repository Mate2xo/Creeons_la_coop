class AddCategoryToProductors < ActiveRecord::Migration[5.2]
  def change
    add_column :productors, :category, :string
  end
end
