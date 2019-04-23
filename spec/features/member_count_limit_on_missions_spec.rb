# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "MemberCountLimitOnMissions", type: :feature do
  let(:member) { create :member }
  let(:mission) { create :mission }
  before { sign_in member }

  describe "enrolling in a mission" do
    before { visit mission_path(mission.id) }

    context "when the enrolled Member count has NOT been reached" do
      it "allows enrolling to that Mission" do
        mission.max_member_count = 4
        mission.member_count = 3
        click_link 'Participer'
        expect(mission.members).to include(member)
        expect(page).to have_content("Vous vous êtes inscrit à cette mission")
      end
    end

    context "when the enrolled Member count has been reached" do
      it "prevents enrolling to that Mission" do
        mission.max_member_count = 4
        mission.member_count = 4
        click_link 'Participer'
        expect(mission.members).to_not include(member)
        expect(page).to have_content("Vous ne participez plus à cette mission")
      end
    end
  end
end
