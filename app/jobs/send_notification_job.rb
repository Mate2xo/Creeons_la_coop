class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)

		members = Member.all

		members.each do |member|
			if member.end_subscription.present? && (member.end_subscription - Date.today <= 7)
				puts member.end_subscription
			end
		end

  end
end
