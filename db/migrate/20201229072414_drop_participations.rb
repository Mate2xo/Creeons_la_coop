class DropParticipations < ActiveRecord::Migration[5.2]
  def up
    drop_table :participations
  end

  def down
    create_table :participations do |t|
      t.references :event, foreign_key: { to_table: :missions }
      t.references :participant, foreign_key: { to_table: :members }

      t.timestamps
    end
  end
end
