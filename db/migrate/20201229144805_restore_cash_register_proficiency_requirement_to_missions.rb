class RestoreCashRegisterProficiencyRequirementToMissions < ActiveRecord::Migration[5.2]
  def change
    add_column :missions, :cash_register_proficiency_requirement, :integer, default: 0
  end
end
