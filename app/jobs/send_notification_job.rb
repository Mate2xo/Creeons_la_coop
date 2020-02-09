# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    members = Member.all
    members.each do |member|
      if member.end_subscription.present? && (Date.today  - member.end_subscription <= 15)
        MemberMailer.end_subscription_alert(member).deliver_now
      end
    end
  end
end
