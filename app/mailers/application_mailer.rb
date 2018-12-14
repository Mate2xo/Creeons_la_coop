# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'timothee.bull@gmail.com'
  layout 'mailer'
end
