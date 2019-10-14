# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id            :bigint(8)        not null, primary key
#  postal_code   :string
#  city          :string           not null
#  street_name_1 :string
#  street_name_2 :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  productor_id  :bigint(8)
#  member_id     :bigint(8)
#  coordinates   :float            is an Array
#

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:city).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:postal_code).of_type(:string) }
      it { is_expected.to have_db_column(:street_name_1).of_type(:string) }
      it { is_expected.to have_db_column(:street_name_2).of_type(:string) }
      it { is_expected.to have_db_column(:coordinates).of_type(:float) }
      it { is_expected.to validate_presence_of(:city) }
    end

    describe 'associations' do
      let(:productor_address) { build_stubbed(:productor_address) }
      let(:member_address) { create(:member_address) }
      let(:missions_address) { create(:missions_address) }

      it { is_expected.to belong_to(:productor).optional }
      it { expect(productor_address.productor).to be_valid }
      it { is_expected.to belong_to(:member).optional }
      it { expect(member_address.member).to be_valid }
      it { is_expected.to have_and_belong_to_many(:missions) }
      it { expect(missions_address.missions).to be_truthy }
    end
  end

  describe "instance coordinates reset for invalid inputs" do
    let(:address) { build(:address) }

    context "when params return any empty string value," do
      it "nullifies .coordinates if coordinates[0] == '' (latitude)" do
        address.coordinates = ['', Faker::Address.longitude]
        address.save
        expect(address.coordinates).to be nil
      end

      it "nullifies .coordinates if coordinates[1] == '' (longitude)" do
        address.coordinates = [Faker::Address.latitude, '']
        address.save
        expect(address.coordinates).to be nil
      end

      it "nullifies .coordinates if coordinates == ['','']" do
        address.coordinates = ['', '']
        address.save
        expect(address.coordinates).to be nil
      end
    end
  end

  describe "instance coordinates search" do
    let(:address) {
      create :address, street_name_1: "4 allée de la faïencerie",
                       street_name_2: "au bout de l'allée",
                       postal_code: "60100"
    }
    describe "#fetch coordinates" do
      it "connects successfully to api-adresse.data.gouv.fr/search/" do
        expect(address.send(:fetch_coordinates).code).to eq 200
      end
    end

    describe "#assign_coordinates" do
      let(:response) { instance_double('HTTParty::Response') }

      context "when the API response is valid" do
        let(:body) {
          "{\"type\": \"FeatureCollection\", \"version\": \"draft\", \"features\": [{\"type\": \"Feature\", \"geometry\": {\"type\": \"Point\", \"coordinates\": [2.470229, 49.259143]}, \"properties\": {\"label\": \"4 Allee de la Faiencerie 60100 Creil\", \"score\": 0.5097866476580893, \"housenumber\": \"4\", \"id\": \"60175_0353_00004\", \"type\": \"housenumber\", \"name\": \"4 Allee de la Faiencerie\", \"postcode\": \"60100\", \"citycode\": \"60175\", \"x\": 661429.37, \"y\": 6906738.95, \"city\": \"Creil\", \"context\": \"60, Oise, Hauts-de-France\", \"importance\": 0.5588726364341049, \"street\": \"Allee de la Faiencerie\"}}], \"attribution\": \"BAN\", \"licence\": \"ODbL 1.0\", \"query\": \"4 all\\u00e9e de la fa\\u00efencerie au bout de la rue\", \"filters\": {\"postcode\": \"60100\"}, \"limit\": 3}"
        }

        before {
          allow(address).to receive(:fetch_coordinates) { response }
          allow(response).to receive(:code) { 200 }
        }

        it "assigns the fetched coordinates to the record" do
          allow(response).to receive(:body) { body }

          address.assign_coordinates

          expect(address.reload.coordinates).to eq [49.259143, 2.470229]
        end

        it "does not assign coordinates if no coordinates are found" do
          modified_body = JSON.parse(body)
          modified_body["features"] = []
          allow(response).to receive(:body) { JSON.generate(modified_body) }

          address.assign_coordinates

          expect(address.coordinates).to be nil
        end
      end

      it "exits gracefully if the API response is invalid" do
        allow(response).to receive(:code) { 400 }
        allow(address).to receive(:fetch_coordinates) { response }
        address.assign_coordinates
      end
    end
  end
end
