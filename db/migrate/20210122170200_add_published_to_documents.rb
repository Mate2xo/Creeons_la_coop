class AddPublishedToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :published, :boolean, default: false
  end
end
