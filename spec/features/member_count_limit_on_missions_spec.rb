# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Member count limit on missions :", type: :feature do
  let(:member) { create :member }
  let(:mission) { create :mission }

  before { sign_in member }

  describe "member enrolling in a mission" do
    before { visit mission_path(mission.id) }

    context "when the enrolled member count has NOT been reached," do
      before { click_link I18n.t("main_app.views.missions.show.button_enroll") }

      it "subscribes the member to this Mission" do
        expect(mission.reload.members).to include(member)
      end

      it { expect(page).to have_content(I18n.t("main_app.views.missions.show.confirm_enroll")) }
    end

    context "when the enrolled Member count has been reached" do
      before {
        mission.max_member_count = 4
        mission.members << create_list(:member, 4)
        mission.save

        click_link I18n.t("main_app.views.missions.show.button_enroll")
      }

      it "does not subscribe the member to this Mission" do
        expect(mission.reload.members).not_to include(member)
      end

      it { expect(page).to have_content(I18n.t("main_app.views.missions.show.cannot_enroll")) }
    end
  end

  describe "member disenrolling from a mission" do
    before {
      mission.members << member
      visit mission_path(mission.id)

      click_link I18n.t("main_app.views.missions.show.button_disenroll")
    }

    it "unsubcribes the member from this mission" do
      expect(mission.reload.members).not_to include(member)
    end

    it { expect(page).to have_content(I18n.t("main_app.views.missions.show.disenroll")) }
  end
end
