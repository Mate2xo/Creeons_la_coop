# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "MemberInvitations", type: :feature do
  let(:super_admin) { create :member, :super_admin }
  before {
    sign_in super_admin
  }

  context "when using the invitation form" do
    it 'sends an invitation email' do
      visit 'members/invitation/new'
      fill_in 'Email', with: 'test@test.com'
      click_button 'Send an invitation'
      expect(Devise.mailer.deliveries.count).to eq 1
      expect(page).to have_content "An invitation email has been sent"
    end
  end
end
