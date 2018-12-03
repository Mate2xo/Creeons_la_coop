class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :name
      t.text :description
      t.date :due_date

      t.timestamps
    end
  end
end
