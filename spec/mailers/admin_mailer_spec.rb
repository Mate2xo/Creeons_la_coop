require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  
  describe "end_subscription_info" do


    context "when a mail is sended" do


      let (:admin) {create :member}

      before(:each) do
        @members = create_list :member, 20, end_subscription: Faker::Date.between(from: 15.days.ago, to: Date.today)
        @members_which_are_not_in_end_subscription = create_list :member, 20, end_subscription: Faker::Date.between(from: 200.days.ago, to: 16.days.ago)
        @mail = AdminMailer.end_subscription_info(admin)
      end

      it "contains the info of the members which are in end of subscription state" do
        @members.each do |member|
          expect(@mail.body.encoded).to include("#{member.first_name} #{member.last_name} #{member.end_subscription}")
        end
      end

      it "not contains the info of the members which are not in end of subscription state" do
        @members_which_are_not_in_end_subscription.each do |member|
          expect(@mail.body.encoded).to_not include("#{member.first_name} #{member.last_name} #{member.end_subscription}")
        end
      end

    end
  end

end
