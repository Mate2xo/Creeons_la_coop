# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Calendar events color codes:", type: :feature do
  before {
    sign_in create(:member)
  }

  context "when a delivery is expected at the shop" do
    let!(:mission) { create :mission, delivery_expected: true }

    it "shows a truck icon on the mission event", js: true do
      visit missions_path
      expect(page).to have_css(".fas.fa-truck")
    end
  end
end
