# frozen_string_literal: true

class AddAuthorRefToInfos < ActiveRecord::Migration[5.2]
  def change
    add_reference :infos, :author, foreign_key: { to_table: :members }
  end
end
