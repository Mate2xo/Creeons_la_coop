# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mission events color codes:' do
  before do
    use_fast_non_js_browser
    sign_in create(:member)
  end

  context 'when a delivery is expected at the shop' do
    it 'shows a truck icon on the mission event' do
      create(:mission, delivery_expected: true)

      visit missions_path

      expect(page).to have_css('.fas.fa-truck')
    end
  end

  context 'when :min_member_count is set' do
    let(:mission) { create(:mission, min_member_count: 3) }

    context 'with insufficient enrolled members', :js do
      before { use_headless_javascript_browser }

      it 'shows the event colored in purple' do
        mission.members << create_list(:member, 2)

        visit missions_path

        expect(first("a[href='/missions/#{mission.id}']").native.style('background-color'))
          .to eq 'rgb(128, 0, 128)'
      end

      it 'shows the event in red if no member if enrolled' do
        mission

        visit missions_path

        expect(first("a[href='/missions/#{mission.id}']").native.style('background-color'))
          .to eq 'rgb(255, 0, 0)'
      end
    end
  end

  context 'when :event is set to true' do
    it 'shows the event colored in orange', :js do
      use_headless_javascript_browser
      mission = create(:mission, genre: 'event')

      visit missions_path

      expect(first("a[href='/missions/#{mission.id}']").native.style('background-color'))
        .to eq 'rgb(255, 165, 0)'
    end
  end

  context 'when a member enrolls for a smaller duration than the full mission duration' do
    it "shows the member's name in light blue", :js do
      mission = create(:mission)
      jack = create(:member, first_name: 'Jack')
      create(:enrollment, :one_hour, mission: mission, member: jack)

      visit mission_path(mission.id)

      expect(find("#member_#{jack.id}")).to have_css('.bg-info')
    end
  end
end
