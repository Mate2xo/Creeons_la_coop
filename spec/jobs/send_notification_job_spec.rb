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

      it "send a mail to all members in end subscription period" do

        end_subscription_period_params = {from: Date.today, to: Date.today + 15}
        members_number = rand(1..500) 
        create_list :member, members_number, end_subscription: Faker::Date.between(end_subscription_period_params)
        member_mails = Member.all.map {|m| m.email}

        ActiveJob::Base.queue_adapter = :test
        SendNotificationJob.perform_now
        email_sended_adress = ActionMailer::Base.deliveries.map {|m| m.to[0]}
        
        expect(member_mails.sort == email_sended_adress.sort).to eq(true)

      end

      it "not send a mail to members which are not in end subscription period" do

        before_end_subscription_period_params = {from: Date.today + 16, to: Date.today + 300}
        members_number = rand(1..500) 

        create_list :member, members_number, end_subscription: Faker::Date.between(before_end_subscription_period_params)

        ActiveJob::Base.queue_adapter = :test
        expect {
          SendNotificationJob.perform_now
        }.to change { ActionMailer::Base.deliveries.size }.by(0) 
      end
     
      it "not send a mail to members which have an outdated subscription date " do

        before_end_subscription_period_params = {from: Date.today - 1, to: Date.today - 300}
        members_number = rand(1..500) 

        create_list :member, members_number, end_subscription: Faker::Date.between(before_end_subscription_period_params)

        ActiveJob::Base.queue_adapter = :test
        expect {
          SendNotificationJob.perform_now
        }.to change { ActionMailer::Base.deliveries.size }.by(0) 
      end

      it "not send a mail to members which have a nil subscription date " do

        members_number = rand(1..500) 

        create_list :member, members_number, nil

        ActiveJob::Base.queue_adapter = :test
        expect {
          SendNotificationJob.perform_now
        }.to change { ActionMailer::Base.deliveries.size }.by(0) 
      end

      it "send mails to the right members" do
        member_which_are_in_end_subscription_period = create :member, end_subscription: Date.today + 10
        member_which_are_not_in_end_subscription_period = create :member, end_subscription: Date.today + 30 
        member_which_have_a_outdated_end_subscription_date = create :member, end_subscription: Date.today - 5
        member_which_have_a_nil_end_end_subscription_date = create :member, end_subscription: nil
        ActiveJob::Base.queue_adapter = :test
        SendNotificationJob.perform_now
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member_which_are_in_end_subscription_period.email}).to eq true
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member_which_are_not_in_end_subscription_period.email}).to eq false
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member_which_have_a_outdated_end_subscription_date.email}).to eq false
        expect(ActionMailer::Base.deliveries.any? {|m| m.to[0] == member_which_have_a_nil_end_end_subscription_date.email}).to eq false
      end

    end
  end
end
