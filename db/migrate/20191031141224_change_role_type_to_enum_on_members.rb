# frozen_string_literal: true

class ChangeRoleTypeToEnumOnMembers < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        change_column_default :members, :role, from: 'member', to: nil
        Member.connection.execute("
          UPDATE members
            SET role =  CASE role
                          WHEN 'member' THEN 0
                          WHEN 'admin' THEN 1
                          WHEN 'super_admin' THEN 2
                        END
        ")

        change_column :members, :role, 'integer USING CAST(role AS integer)'
        change_column_default :members, :role, from: nil, to: 0
      end

      dir.down do
        change_column :members, :role, 'varchar USING CAST(role AS varchar)'

        change_column_default :members, :role, from: 0, to: 'member'
        Member.connection.execute("
          UPDATE members
            SET role =  CASE role
                          WHEN '0' THEN 'member'
                          WHEN '1' THEN 'admin'
                          WHEN '2' THEN 'super_admin'
                        END
        ")
      end
    end
  end
end
