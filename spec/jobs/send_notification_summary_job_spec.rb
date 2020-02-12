require 'rails_helper'

RSpec.describe SendNotificationSummaryJob, type: :job do

  context 'when the mails is sended' do

    it 'send mails only to the admins' do
      ActiveJob::Base.queue_adapter = :test
      SendNotificationSummaryJob.perform_now
      admins = Member.where(role: 'admin')

      admins.each do |admin|
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == admin.email}).to eq true
      end
      expect(ActionMailer::Base.deliveries.size).to eq admins.size
    end
  end
end
