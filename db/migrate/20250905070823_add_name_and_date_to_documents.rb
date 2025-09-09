# frozen_string_literal: true

# Allow admins to edit document names, and sort them by date
class AddNameAndDateToDocuments < ActiveRecord::Migration[7.1]
  def change
    change_table :documents, bulk: true do |t|
      t.string :name
      t.date :date
    end
  end
end
