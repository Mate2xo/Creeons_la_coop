class CreateJoinTableManagerProductor < ActiveRecord::Migration[5.2]
  def change
    create_join_table :members, :productors do |t|
      # t.index [:member_id, :productor_id]
      # t.index [:productor_id, :member_id]
    end
  end
end
