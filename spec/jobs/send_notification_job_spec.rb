# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendNotificationJob, type: :job do
  subject { ActionMailer::Base.deliveries }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  context "when members are in end subscription period" do
    it "sends an email to all of them" do
      end_subscription_period_params = { from: Date.today, to: Date.today + 15 }
      create_list :member, 5, end_subscription: Faker::Date.between(end_subscription_period_params)
      member_mails = Member.all.map(&:email)
      SendNotificationJob.perform_now

      expect(subject.map { |m| m.to[0] }).to match_array(member_mails)
    end
  end

  context "when members are not in end subscription period" do
    it "does not sends an email" do
      before_end_subscription_period_params = { from: Date.today + 16, to: Date.today + 300 }
      create_list :member, 5, end_subscription: Faker::Date.between(before_end_subscription_period_params)
      SendNotificationJob.perform_now

      expect(subject.size).to eq(0)
    end
  end

  context "when members have an outdated subscription date" do
    it "does not sends an email" do
      before_end_subscription_period_params = { from: Date.today - 1, to: Date.today - 300 }
      create_list :member, 5, end_subscription: Faker::Date.between(before_end_subscription_period_params)
      SendNotificationJob.perform_now

      expect(subject.size).to eq(0)
    end
  end

  context "when members have a nil subscription date" do
    it "does not sends an email" do
      create_list :member, 5, end_subscription: nil
      SendNotificationJob.perform_now

      expect(subject.size).to eq(0)
    end
  end
end
