# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MemberInvitations' do
  subject(:fill_email_and_submit) do
    visit new_member_invitation_path
    fill_in Member.human_attribute_name(:email), with: 'test@test.com'
    click_button "Envoyer l'invitation"
  end

  before do
    use_fast_non_js_browser
    sign_in create(:member, :super_admin)
  end

  let(:super_admin) { create(:member, :super_admin) }

  it 'sends an invitation email', :aggregate_failures do
    fill_email_and_submit

    expect(Devise.mailer.deliveries.count).to eq 1
    expect(page).to have_content "Un e-mail d'invitation a été envoyé"
  end

  it 'creates an unvalidated user', :aggregate_failures do
    fill_email_and_submit

    expect(Member.count).to eq 2
    expect(Member.last.email).to eq 'test@test.com'
    expect(Member.last.first_name).to be_nil
    expect(Member.last.last_name).to be_nil
  end

  it 'redirects to the same page when the invitation is sent, to allow quick multiple invitations' do
    fill_email_and_submit
    expect(page).to have_current_path('/members/invitation/new', ignore_query: true)
  end

  context 'when filling an invalid email' do
    subject(:fill_invalid_email_and_submit) do
      visit new_member_invitation_path
      fill_in Member.human_attribute_name(:email), with: 'wrong_email'
      click_button "Envoyer l'invitation"
    end

    it 'does not send an invitation to an invalid email' do
      fill_invalid_email_and_submit
      expect(Devise.mailer.deliveries.count).to eq 0
    end
  end

  context "when following the invitation mail's link" do
    subject(:follow_invitation_link) do
      open_email 'test@test.com'
      visit_in_email "Accepter l'invitation"
    end

    before do
      visit new_member_invitation_path
      fill_in Member.human_attribute_name(:email), with: 'test@test.com'
      click_button "Envoyer l'invitation"
      click_link 'Déconnexion'
    end

    it 'allows the user to finalize his account creation' do
      follow_invitation_link
      fill_in 'Prénom', with: 'first_name'
      fill_in 'Nom de famille', with: 'last_name'
      fill_in 'Mot de passe',  with: 'password'
      fill_in 'Confirmez votre mot de passe', with: 'password'
      click_button 'Confirmer'

      expect(page).to have_content 'Votre compte et votre mot de passe ont été créés. Vous êtes maintenant connecté.'
    end
  end
end
