# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Autocheck checkboxes in enrollments forms', type: :feature do
  let(:member) { create :member }
  let(:mission) { create :mission, genre: 'regulated' }

  before { sign_in member }

  context 'when the current member have already taken a timeslot in mission' do
    it 'autocheck the checkboxes of this timeslots in quick enrollment form' do
      create :enrollment, member: member, mission: mission

      visit mission_path(mission.id)

      checkboxes = page.all(:checkbox)
      expect(checkboxes).to all be_checked
    end

    it 'autocheck the checkboxes of this timeslots in enrollment fields' do
      create :enrollment, member: member, mission: mission

      visit edit_mission_path(mission.id)

      checkboxes = page.all(:checkbox, id: /.*0_time_slots.*/)
      expect(checkboxes).to all be_checked
    end
  end
end
