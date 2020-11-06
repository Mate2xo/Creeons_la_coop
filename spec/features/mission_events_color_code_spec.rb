# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mission events color codes:', type: :feature do
  let(:current_member) { create :member, first_name: 'jack' }

  let(:create_mission_with_slots) do
    create :mission, name: 'my_mission',
                     max_member_count: 4,
                     event: false,
                     with_slots: true
  end

  before { sign_in current_member }

  context "when a delivery is expected at the shop" do
    it "shows a truck icon on the mission event", js: true do
      create :mission, delivery_expected: true

      visit missions_path

      expect(page).to have_css(".fas.fa-truck")
    end
  end

  context "when :min_member_count is set" do
    let(:mission) { create :mission, min_member_count: 3 }

    context "with insufficient enrolled members", js: true do
      it "shows the event colored in purple" do
        mission.members << create_list(:member, 2)

        visit missions_path

        expect(first("a[href='/missions/#{mission.id}']").native.style('background-color'))
          .to eq 'rgb(128, 0, 128)'
      end

      it "shows the event in red if no member if enrolled" do
        mission

        visit missions_path

        expect(first("a[href='/missions/#{mission.id}']").native.style('background-color'))
          .to eq 'rgb(255, 0, 0)'
      end
    end
  end

  context "when :event is set to true" do
    it "shows the event colored in orange", js: true do
      mission = create :mission, event: true

      visit missions_path

      expect(first("a[href='/missions/#{mission.id}']").native.style('background-color'))
        .to eq 'rgb(255, 165, 0)'
    end
  end

  context "when a member enrolls for a smaller duration than the full mission duration" do
    it "shows the member's name in light blue", js: true do
      mission = create_mission_with_slots
      jack = create :member, first_name: 'jack'
      enroll(mission, jack)

      visit mission_path(mission.id)

      expect(find("#member_#{jack.id}")).to have_css('.bg-info')
    end
  end
end
