# frozen_string_literal: true

# Further classify documents within a given category
class CreateDocumentsSubCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :documents_sub_categories do |t|
      t.string :name
      t.references :category, null: false, foreign_key: {to_table: :documents_categories}

      t.timestamps

      t.index %i[name category_id], unique: true
    end

    add_reference :documents, :sub_category, foreign_key: {to_table: :documents_sub_categories}
  end
end
