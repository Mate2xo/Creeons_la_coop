# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "MemberInvitations", type: :feature do
  let(:super_admin) { create :member, :super_admin }
  before {
    sign_in super_admin
    visit 'members/invitation/new'
    fill_in 'Email', with: 'test@test.com'
    click_button 'Send an invitation'
  }

  context "when using the invitation form" do
    it 'sends an invitation email' do
      expect(Devise.mailer.deliveries.count).to eq 1
      expect(page).to have_content "An invitation email has been sent"
    end

    it 'creates an unvalidated user' do
      invalid_user = Member.last
      expect(Member.count).to eq 2
      expect(invalid_user.email).to eq 'test@test.com'
      expect(invalid_user.first_name).to eq nil
      expect(invalid_user.last_name).to eq nil
    end
  end

  context "when following the invitation mail's link" do
    before {
      click_link "Déconnexion"
      open_email "test@test.com"
      visit_in_email "Accept invitation"
    }
    it "allows the user to finalize his account creation" do
      fill_in "Prénom", with: 'first_name'
      fill_in "Nom de famille", with: 'last_name'
      fill_in "Mot de passe",	with: "password"
      fill_in "Confirmez votre mot de passe",	with: "password"
      click_button "Set my password"

      expect(page).to have_content "Your account and password were set successfully"
    end
  end
end
