# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  
  default from: Rails.application.credentials.dig(:noreply_mail_address) || 'no-reply@example.com'
  
  def end_subscription_info(admin)
    @members = Member.where(":start_date <= end_subscription AND end_subscription <= :end_date", {start_date: Date.today, end_date: Date.today + 15})
    mail(to: admin.email, subject: "Liste des membres en fin de souscription")
  end

end
