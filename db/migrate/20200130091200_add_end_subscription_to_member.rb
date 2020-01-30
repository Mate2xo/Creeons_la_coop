class AddEndSubscriptionToMember < ActiveRecord::Migration[5.2]
  def change
		add_column :member, :end_subscription, :datetime
  end
end
