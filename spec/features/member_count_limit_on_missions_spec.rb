# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Member count limit on missions :', type: :feature do
  let(:member) { create :member }
  let(:mission) { create :mission }

  before { sign_in member }

  describe 'member enrolling in a mission' do
    it 'subscribes the member to this Mission' do
      visit mission_path(mission.id)
      check mission.start_date.strftime('slot_start_times_%F_%H%M%S_utc')
      check (mission.start_date + 90.minutes).strftime('slot_start_times_%F_%H%M%S_utc')
      click_button I18n.t('missions.enrollment_form.button_enroll_to_slots')

      expect(mission.reload.members).to include(member)
      expect(page).to have_content(I18n.t('slots.update.confirm_update'))
    end
  end
end
