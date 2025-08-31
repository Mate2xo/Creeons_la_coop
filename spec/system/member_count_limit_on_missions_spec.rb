# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Member count limit on missions :' do
  before do
    use_fast_non_js_browser
    sign_in member
  end

  describe 'member enrolling in a mission' do
    subject(:enroll) do
      visit mission_path(mission.id)
      click_button I18n.t('missions.standard_quick_enrollment_form.button_enroll')
    end

    let(:member) { create(:member) }
    let(:mission) { create(:mission) }

    it 'subscribes the member to this Mission' do
      enroll
      expect(mission.reload.members).to include(member)
    end

    it 'shows a confirmation flash message' do
      enroll
      expect(page).to have_content(I18n.t('enrollments.create.confirm_enroll'))
    end

    context 'when the enrolled Member count has been reached' do
      let(:mission) { create(:mission, max_member_count: 4, with_enrollments: 4) }

      it 'does not subscribe the member to this Mission' do
        enroll
        expect(mission.reload.members).not_to include(member)
      end

      it 'sets a feedback message to the user', :js do
        enroll
        expect(page).to have_content(I18n.t('activerecord.errors.models.enrollment.attributes.mission.full'))
      end
    end
  end

  describe 'member disenrolling from a mission' do
    subject(:disenroll) do
      visit mission_path(mission.id)
      click_link I18n.t('missions.standard_quick_enrollment_form.button_disenroll')
    end

    let(:member) { create(:member) }
    let(:mission) { create(:mission) { |m| m.members << member } }

    it 'unsubcribes the member from this mission' do
      disenroll

      expect(mission.reload.members).not_to include(member)
    end

    it 'shows a confirmation message' do
      disenroll
      expect(page).to have_flash :alert, text: I18n.t('enrollments.destroy.disenroll')
    end
  end
end
