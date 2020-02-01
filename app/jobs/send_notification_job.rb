class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)

		members = Member.all

		members.each do |member|
			if member.end_subscription.present? && ((member.end_subscription - Date.today == 7) || (member.end_subscription - Date.today == 3))
				MemberMailer.welcome_email(member).deliver_now
			end
		end

  end
end
