# frozen_string_literal: true

class MemberMailer < ApplicationMailer
  default from: Rails.application.credentials.dig(:noreply_mail_address) || 'no-reply@example.com'

  def end_subscription_alert(member)
    @member = member
    mail(to: @member.email, subject: "Notification de fin d'inscription")
  end
end
