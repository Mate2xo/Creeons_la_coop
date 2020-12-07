class CreateParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :participations do |t|
      t.references :event, foreign_key: { to_table: :missions }
      t.references :participant, foreign_key: { to_table: :members }

      t.timestamps
    end
  end
end
