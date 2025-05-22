# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Members cash register proficiency' do
  let(:jack) { create(:member, cash_register_proficiency: :proficient) }

  before { sign_in jack }

  describe 'mission details page' do
    subject(:mission_show) { visit mission_path(mission.id) }

    before { use_fast_non_js_browser }

    let(:mission) { create(:mission) { |m| m.members << jack } }

    it 'shows enrolled members proficiency' do
      mission_show

      proficiency_level_translation =
        I18n.t(jack.cash_register_proficiency, scope: 'activerecord.attributes.member.cash_register_proficiencies')
      expect(page).to have_content(proficiency_level_translation)
    end
  end

  describe 'mission index page' do
    subject(:mission_index) do
      create(:mission, id: 1234) do |mission|
        mission.members << create_list(:member, 3, cash_register_proficiency: :untrained)
      end
      visit missions_path
    end

    before { use_headless_javascript_browser }

    it 'shows missions without proficient members in purple' do
      mission_index

      expect(first("a[href='/missions/1234']").native.style('background-color'))
        .to eq 'rgb(128, 0, 128)'
    end
  end
end
