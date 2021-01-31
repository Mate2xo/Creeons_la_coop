class AddPublishedToInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :infos, :published, :boolean, default: false
  end
end
