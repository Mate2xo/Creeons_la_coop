class CreateJoinTableAdressmission < ActiveRecord::Migration[5.2]
  def change
    create_join_table :adresses, :missions do |t|
      t.index [:adress_id, :mission_id]
      t.index [:mission_id, :adress_id]
    end
  end
end
