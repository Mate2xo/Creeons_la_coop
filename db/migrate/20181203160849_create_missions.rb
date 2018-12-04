class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :name
      t.text :description
      t.datetime :due_date
      t.string :member
      t.string :author
      t.timestamps
    end
  end
end
