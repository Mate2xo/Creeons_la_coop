class AddColumnLocalToProductors < ActiveRecord::Migration[5.2]
  def change
    add_column :productors, :local, :boolean, default: false
  end
end
