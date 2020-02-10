class SendNotificationSummaryJob < ApplicationJob
  queue_as :default

  def perform(*args)

    admins = Member.where(role: 'admin')
    admins.each do |admin|
      AdminMailer.end_subscription_info(admin).deliver_now
    end
  end
end
