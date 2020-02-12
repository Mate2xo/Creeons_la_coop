# frozen_string_literal: true

class SendNotificationJob < ApplicationJob
  queue_as :default


  def perform(*_args)
    members = Member.where(":start_date <= end_subscription AND end_subscription <= :end_date", {start_date: Date.today, end_date: Date.today + 15})
    members.each do |member|
        MemberMailer.end_subscription_alert(member).deliver_now
    end
    
  end

end
