# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Member count limit on missions :', type: :feature do
  let(:member) { create :member }
  let(:mission) { create :mission }

  before { sign_in member }

  describe 'member enrolling in a mission' do
    context 'when the enrolled member count has NOT been reached,' do
      before do
        visit mission_path(mission.id)
        click_button I18n.t('main_app.views.missions.show.button_enroll')
      end

      it 'subscribes the member to this Mission' do
        expect(mission.reload.members).to include(member)
      end

      it { expect(page).to have_content(I18n.t('enrollments.create.confirm_enroll')) }
    end

    context 'when the enrolled Member count has been reached' do
      before do
        mission.max_member_count = 4
        mission.members << create_list(:member, 4)
        mission.save

        visit mission_path(mission.id)
        I18n.locale = :fr
        click_button I18n.t('main_app.views.missions.show.button_enroll')
      end

      it 'does not subscribe the member to this Mission' do
        expect(mission.reload.members).not_to include(member)
      end

      it 'sets a feedback message to the user', js: true do
        expect(page).to have_content(I18n.t('enrollments.create.max_member_count_reached'))
      end
    end
  end

  describe 'member disenrolling from a mission' do
    before do
      mission.members << member
      visit mission_path(mission.id)

      click_link I18n.t('main_app.views.missions.show.button_disenroll')
    end

    it 'unsubcribes the member from this mission' do
      expect(mission.reload.members).not_to include(member)
    end

    it { expect(page).to have_content(I18n.t('enrollments.destroy.disenroll')) }
  end
end
