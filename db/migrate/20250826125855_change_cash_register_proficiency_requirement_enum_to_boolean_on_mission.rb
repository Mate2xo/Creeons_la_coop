# frozen_string_literal: true

# :cash_register_proficiency_requirement enum is not needed anymore on Missions.
# We replace it with a Boolean to simplify related logic
class ChangeCashRegisterProficiencyRequirementEnumToBooleanOnMission < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      requirements = {untrained: 0, beginner: 1, proficient: 2}
      dir.up do
        add_column :missions, :cash_register_close_out_required, :boolean, default: false, null: false
        Mission.reset_column_information

        Mission.where(cash_register_proficiency_requirement: requirements[:proficient])
               .find_each do |mission|
          mission.update! cash_register_close_out_required: true
        end

        remove_column :missions, :cash_register_proficiency_requirement, :integer, default: 0
      end

      dir.down do |_dir|
        add_column :missions, :cash_register_proficiency_requirement, :integer, default: 0
        Mission.reset_column_information

        Mission.where(cash_register_close_out_required: true)
               .find_each do |mission|
          mission.update! cash_register_proficiency_requirement: requirements[:proficient]
        end

        remove_column :missions, :cash_register_close_out_required, :boolean, default: false, null: false
      end
    end
  end
end
