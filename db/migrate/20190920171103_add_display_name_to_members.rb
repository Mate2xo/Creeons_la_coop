# frozen_string_literal: true

class AddDisplayNameToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :display_name, :string

    reversible do |dir|
      dir.up do
        DbTextSearch::CaseInsensitive.add_index(
          connection, Thredded.user_class.table_name, Thredded.user_name_column, unique: true
        )
      end
      dir.down do
        remove_index Thredded.user_class.table_name, name: "#{Thredded.user_class.table_name}_#{Thredded.user_name_column}_lower"
      end
    end

    Member.all.each(&:save)
  end
end
