class RemoveCashRegisterProficiencyRequirementFromMissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :missions, :cash_register_proficiency_requirement, :integer
  end
end
