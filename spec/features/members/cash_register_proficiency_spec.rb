# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/slot_enrollment.rb'

RSpec.configure do |c|
  c.include Helpers::SlotEnrollment
end

RSpec.describe 'Members cash register proficiency', type: :feature do
  let(:mission) { create :mission }
  let(:jack) { create :member, cash_register_proficiency: :proficient }

  before { sign_in jack }

  context 'when on a mission details page' do
    it 'shows enrolled members proficiency' do
      enroll(mission, jack)

      visit mission_path(mission.id)

      expect(page).to have_content(
        I18n.translate(jack.cash_register_proficiency,
                       scope: 'activerecord.attributes.member.cash_register_proficiencies')
      )
    end
  end

  context 'when on the mission index page' do
    let(:enroll_three_members) do
      members = create_list(:member, 3, cash_register_proficiency: :untrained)
      members.each do |member|
        enroll(mission, member)
      end
    end

    it 'shows missions without proficient members in purple', js: true do
      enroll_three_members

      visit missions_path

      expect(first("a[href='/missions/#{mission.id}']").native.style('background-color'))
        .to eq 'rgb(128, 0, 128)'
    end
  end
end
