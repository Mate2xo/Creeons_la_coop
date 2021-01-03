# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cash register proficiency checking :', type: :feature do
  let(:member) { create :member }

  before { sign_in member }

  context 'when the cash register proficiency is insufficient, and there is only one slot left on a given time_slot' do
    subject(:enroll) do
      visit mission_path(mission.id)
      I18n.locale = :fr
      check "enrollment_time_slots_#{mission.start_date.strftime('%F_%H%M%S_utc')}"
      click_button I18n.t('main_app.views.missions.show.button_enroll')
    end

    let(:expected_message) do
      I18n.t('enrollments.create.insufficient_proficiency',
             start_time: start_time.first.strftime('%H:%M'),
             end_time: (start_time.first + 90.minutes).strftime('%H:%M'))
    end
    let(:mission) { create :mission, genre: 'regulated', cash_register_proficiency_requirement: 'proficient' }
    let(:start_time) { [mission.start_date, mission.start_date + 90.minutes] }

    it "doesn't enroll", js: true do
      enroll_members_on_mission(3, mission)

      enroll

      expect(page).to have_content(expected_message)
    end
  end

  def enroll_members_on_mission(members_count, mission)
    members = create_list :member, members_count
    members.each do |member|
      create :enrollment,
             mission: mission,
             member: member,
             start_time: [mission.start_date, mission.start_date + 90.minutes]
    end
  end
end
