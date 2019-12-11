# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Members cash register proficiency", type: :feature do
  let(:mission) { create :mission }

  context "when on a mission details page" do
    let(:sandy) { create :member }
    let(:jack) { create :member, cash_register_proficiency: :proficient }

    before {
      mission.members << jack
      sign_in sandy
      visit mission_path(mission.id)
    }

    it "shows enrolled members proficiency" do
      expect(page).to have_content(jack.cash_register_proficiency)
    end
  end
end
