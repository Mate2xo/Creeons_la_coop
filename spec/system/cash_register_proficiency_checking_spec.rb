# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cash register proficiency checking :' do
  before do
    use_fast_non_js_browser
    sign_in create(:member)
  end

  context 'when the cash register proficiency is insufficient, and there is only one slot left on a given time_slot' do
    subject(:enroll_current_user) do
      visit mission_path(mission.id)
      check "enrollment_time_slots_#{mission.start_date.strftime('%F_%H%M%S_utc')}"
      click_button I18n.t('missions.standard_quick_enrollment_form.button_enroll')
    end

    let(:expected_message) do
      I18n.t('activerecord.errors.models.enrollment.insufficient_cash_register_proficiency')
    end
    let(:mission) { create(:mission, genre: :regulated) }

    it "doesn't enroll the current user" do
      enroll_members_on_mission(3, mission)

      enroll_current_user

      expect(page).to have_content(expected_message)
    end
  end

  def enroll_members_on_mission(members_count, mission)
    members = create_list(:member, members_count)
    members.each do |member|
      create(:enrollment, mission: mission, member: member)
    end
  end
end
