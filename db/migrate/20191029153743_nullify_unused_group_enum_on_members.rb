# frozen_string_literal: true

class NullifyUnusedGroupEnumOnMembers < ActiveRecord::Migration[5.2]
  def change
    # enum group 0 is called "no_group" (useless)
    reversible do |dir|
      Member.reset_column_information
      dir.up do
        execute 'UPDATE members SET "group" = NULL WHERE members.group = 0;'
      end

      dir.down do
        Member.where(group: nil).each { |member|
          member.update(group: 0) unless Member.groups[:no_group].nil?
        }
      end
    end
  end
end
