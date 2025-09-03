# frozen_string_literal: true

# :cash_register_proficiency_requirement enum is not needed anymore on Missions.
# We replace it with a Boolean to simplify related logic
class ChangeCashRegisterProficiencyRequirementEnumToBooleanOnMission < ActiveRecord::Migration[7.1]
  ##
  # Replace the integer `cash_register_proficiency_requirement` enum on missions with a boolean `cash_register_close_out_required`,
  # migrating existing data and providing a reversible down path.
  #
  # Up migration:
  # - Adds `missions.cash_register_close_out_required` (boolean, default: false, null: false).
  # - Marks records with `cash_register_proficiency_requirement == :proficient` as `cash_register_close_out_required = true`.
  # - Removes the `cash_register_proficiency_requirement` integer column.
  #
  # Down migration:
  # - Restores `missions.cash_register_proficiency_requirement` (integer, default: 0).
  # - Sets `cash_register_proficiency_requirement = :proficient` for records where `cash_register_close_out_required` is true.
  # - Removes the `cash_register_close_out_required` boolean column.
  #
  # The migration uses the mapping `{ untrained: 0, beginner: 1, proficient: 2 }` for the enum values
  # and calls `Mission.reset_column_information` after schema changes to ensure ActiveRecord sees the new/removed columns
  # before updating rows.
  def change
    reversible do |dir|
      requirements = {untrained: 0, beginner: 1, proficient: 2}
      dir.up do
        add_column :missions, :cash_register_close_out_required, :boolean, default: false, null: false
        Mission.reset_column_information

        Mission.where(cash_register_proficiency_requirement: requirements[:proficient])
               .update_all cash_register_close_out_required: true

        remove_column :missions, :cash_register_proficiency_requirement, :integer, default: 0, null: false
      end

      dir.down do |_dir|
        add_column :missions, :cash_register_proficiency_requirement, :integer, default: 0
        Mission.reset_column_information

        Mission.where(cash_register_close_out_required: true)
               .update_all cash_register_proficiency_requirement: requirements[:proficient]

        remove_column :missions, :cash_register_close_out_required, :boolean, default: false, null: false
      end
    end
  end
end
