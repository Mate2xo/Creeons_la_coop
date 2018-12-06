class MemberMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Nouvelle inscription" )
  end
  
end
