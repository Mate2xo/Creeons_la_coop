# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendNotificationJob, :type => :job do
  describe "SendNotificationJob" do
    it "is enqueued" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        SendNotificationJob.perform_later
      }.to have_enqueued_job
    end


    context "when the job must send mails to the members" do

     it "send a great number of mail" do
        rand_number1 = rand(100)
        rand_number2 = rand(100)
        rand_number3 = rand(100)

        create_list :member, rand_number1, end_subscription: Faker::Date.between(from: 15.days.ago, to: Date.today)
        create_list :member, rand_number2, end_subscription: Date.today - rand(16..30)
        create_list :member, rand_number3, end_subscription: nil

        ActiveJob::Base.queue_adapter = :test
        expect {
          SendNotificationJob.perform_now
        }.to change { ActionMailer::Base.deliveries.size }.by(rand_number1) 
      end

      it "send mails to the right members" do
        member1 = create :member, end_subscription: Date.today - 10
        member2 = create :member, end_subscription: Date.today - 30 
        member3 = create :member, end_subscription: Date.today - 5
        member4 = create :member, end_subscription: Date.today + 5
        ActiveJob::Base.queue_adapter = :test
        SendNotificationJob.perform_now
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member1.email}).to eq true
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member2.email}).to eq false
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member3.email}).to eq true
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member4.email}).to eq false
      end
    end


  end
end
