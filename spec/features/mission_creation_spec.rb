# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "MissionCreations", type: :feature do
  describe "creating a mission" do
    let(:super_admin) { create :member, :super_admin }

    before {
      sign_in super_admin
      visit new_mission_path
    }

    context "when every field are filled-in" do
      it "creates a mission" do
        fill_in "Nom de la mission", with: "Title"
        fill_in "Description", with: "Title"
        fill_in "Date de début", with: "Title"
        fill_in "Date limite", with: "Title"
        fill_in "Nombre de personnes minimun souhaité", with: 3
        fill_in "Nombre maximum de participants", with: 5
      end
    end
  end
end
