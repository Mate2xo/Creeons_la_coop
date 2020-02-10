# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default


  def perform(*_args)
    
    members.each do |member|
      if member.end_subscription.present? && (Date.today - 15 <= member.end_subscription && member.end_subscription <= Date.today)
        MemberMailer.end_subscription_alert(member).deliver_now
      end
    end
    
  end

end
