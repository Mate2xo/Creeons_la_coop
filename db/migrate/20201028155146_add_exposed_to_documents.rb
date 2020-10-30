class AddExposedToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :exposed, :boolean
  end
end
