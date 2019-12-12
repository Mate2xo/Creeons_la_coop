# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Members cash register proficiency", type: :feature do
  let(:mission) { create :mission }
  let(:jack) { create :member, cash_register_proficiency: :proficient }

  before { sign_in jack }

  context "when on a mission details page" do
    before {
      mission.members << jack
      visit mission_path(mission.id)
    }

    it "shows enrolled members proficiency" do
      expect(page).to have_content(
        I18n.translate(jack.cash_register_proficiency,
                       scope: "activerecord.attributes.member.cash_register_proficiencies")
      )
    end
  end

  context "when on the mission index page" do
    before {
      mission.members << create_list(:member, 3, cash_register_proficiency: :untrained)
      visit missions_path
    }

    it "shows missions without proficient members in purple", js: true do
      expect(find("a[href='/missions/#{mission.id}']").native.style('background-color'))
        .to eq 'rgb(128, 0, 128)'
    end
  end
end
