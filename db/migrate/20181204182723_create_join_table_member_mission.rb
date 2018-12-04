class CreateJoinTableMemberMission < ActiveRecord::Migration[5.2]
  def change
    create_join_table :members, :missions do |t|
      # t.index [:member_id, :mission_id]
      # t.index [:mission_id, :member_id]
    end
  end
end
