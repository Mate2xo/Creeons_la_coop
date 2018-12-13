class AddConfirmableToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :confirmation_token, :string
    add_index :members, :confirmation_token
    add_column :members, :confirmed_at, :datetime
    add_column :members, :confirmation_sent_at, :datetime
    add_column :members, :unconfirmed_email, :string
  end
end
