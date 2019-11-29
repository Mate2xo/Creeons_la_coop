# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "Member count limit on missions :", type: :feature do
  let(:member) { create :member }
  let(:mission) { create :mission }
  before { sign_in member }

  describe "enrolling in a mission" do
    before { visit mission_path(mission.id) }

    context "when the enrolled Member count has NOT been reached" do
      it "allows enrolling to that Mission" do
        click_link I18n.t("main_app.views.missions.show.button_enroll")

        expect(mission.reload.members).to include(member)
        expect(page).to have_content(I18n.t("main_app.views.missions.show.confirm_enroll"))
      end
    end

    context "when the enrolled Member count has been reached" do
      it "prevents enrolling to that Mission" do
        mission.max_member_count = 4
        mission.members << create_list(:member, 4)
        mission.save

        click_link I18n.t("main_app.views.missions.show.button_enroll")

        expect(mission.reload.members).to_not include(member)
        expect(page).to have_content(I18n.t("main_app.views.missions.show.cannot_enroll"))
      end
    end
  end

  describe "disenrolling from a mission" do
    before {
      mission.members << member
      visit mission_path(mission.id)
    }

    it "unsubcribes a member" do
      click_link I18n.t("main_app.views.missions.show.button_disenroll")

      expect(mission.reload.members).not_to include(member)
      expect(page).to have_content(I18n.t("main_app.views.missions.show.disenroll"))
    end
  end
end
