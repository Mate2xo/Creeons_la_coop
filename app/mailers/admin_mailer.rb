# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  
  default from: Rails.application.credentials.dig(:noreply_mail_address) || 'no-reply@example.com'
  
  def end_subscription_info(admin)
    @admin = admin
    mail(to: @admin.email, subject: "Liste des membres en fin de souscription")
  end

end
