# frozen_string_literal: true

class AddIndexToDisplayNameOfMembers < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Thredded.user_class.reset_column_information

        DbTextSearch::CaseInsensitive.add_index(
          connection, Thredded.user_class.table_name, Thredded.user_name_column, unique: true
        )

        Thredded.user_class.all.each(&:save)
      end

      dir.down do
        remove_index Thredded.user_class.table_name, name: "#{Thredded.user_class.table_name}_#{Thredded.user_name_column}_lower"
      end
    end
  end
end
