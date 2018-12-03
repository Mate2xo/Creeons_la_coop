class CreateJoinTableAdressmission < ActiveRecord::Migration[5.2]
  def change
    create_join_table :adresses, :missions, id: false do |t|
      t.belongs_to :adresses, index: true
      t.belongs_to :missions, index: true
    end
  end
end
