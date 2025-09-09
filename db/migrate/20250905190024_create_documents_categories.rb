# frozen_string_literal: true

# Document categories now need to be CRUDed by admins, along with sub-categories.
class CreateDocumentsCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :documents_categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :documents_categories, :name, unique: true
    add_reference :documents, :category, foreign_key: {to_table: :documents_categories}
  end
end
