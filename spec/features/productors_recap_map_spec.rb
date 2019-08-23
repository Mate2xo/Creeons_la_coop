# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "ProductorsRecapMaps", type: :feature do
  describe "address coordinates auto-search" do
    context "when a new productor is created" do
      let(:productor) { build :productor }

      context "and an address is given," do
        before {
          productor.address = build :address
          allow(productor.address).to receive(:fetch_coordinates)
        }

        it "fetches coordinates if no coordinates are given" do
          productor.address.coordinates = nil
          productor.save
          expect(productor.address).to have_received(:fetch_coordinates)
        end

        it "does not fetch coordinates if coordinates are given" do
          productor.save
          expect(productor.address).not_to have_received(:fetch_coordinates)
        end
      end
    end

    context "when a productor is updated" do
      let(:productor) { create :productor, address: build(:address) }
      before {
        productor
        allow(productor.address).to receive(:fetch_coordinates)
      }

      context "and its address is also updated," do
      #   it "fetches coordinates if no new coordinates are given" do
      #     new_address = attributes_for :address, coordinates: nil
      #     expect(productor.address).to receive(:fetch_coordinates)
      #     binding.pry
      #     productor.update({address_attributes: new_address})
      #   end

        it "does not fetch new coordinates if new coordinates are given" do
          new_address = attributes_for :address
          productor.update(address_attributes: new_address)
          expect(productor.address).not_to have_received(:fetch_coordinates)
        end
      end

      context "and its address is not updated," do
        it "does not fetch coordinates" do
          skip
        end
      end
    end

    context "when an address that doesn't belong to a productor is saved," do
      let(:address) { build :address, coordinates: nil }

      it "doesn't launch Address#fetch_coordinates for a Member" do
        member = build :member
        member.address = address
        allow(member.address).to receive(:fetch_coordinates)

        member.save

        expect(member.address).not_to have_received(:fetch_coordinates)
      end

      it "doesn't launch Address#fetch_coordinates for a Mission" do
        mission = build :mission
        mission.addresses << address
        allow(mission.addresses[0]).to receive(:fetch_coordinates)

        mission.save

        expect(mission.addresses[0]).not_to have_received(:fetch_coordinates)
      end
    end
  end
end
