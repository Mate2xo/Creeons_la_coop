# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "ProductorsRecapMaps", type: :feature do
  describe "address coordinates auto-search" do
    context "when a new productor is created" do
      let(:productor) { build :productor }

      context "and an address is given" do
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
      context "and its address is also updated" do
        it "fetches new coordinates if no new coordinates are given" do
        end

        it "does not fetch new coordinates if new coordinates are given" do
        end
      end

      context "and its address is not updated" do
        it "does not fetch coordinates" do
        end
      end
    end
  end
end
