class RemoveEventFromMissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :missions, :event, :boolean
  end
end
