# frozen_string_literal: true

class MemberMailer < ApplicationMailer
  default from: 'no-reply@monsite.fr'

  def alert_end_of_souscription_email(member)
    @member = member

    mail(to: @member.email, subject: "Notification de fin d'inscription")
  end
end
