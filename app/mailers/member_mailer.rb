# frozen_string_literal: true

class MemberMailer < ApplicationMailer

  default from: Rails.application.credentials.dig(:noreply_mail_address) || 'no-reply@example.com'
  
  def alert_end_of_souscription_email(member)
    member = member
    mail(to: @member.email, subject: "Notification de fin d'inscription")
  end
end
