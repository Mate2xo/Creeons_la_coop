# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Productors Recap Maps address coordinates auto-search', type: :feature do
  context 'when a new productor is created,' do
    let(:productor) { build :productor }

    context 'when an address is given,' do
      it 'fetches coordinates if no coordinates are given' do
        productor.address = build :address
        allow(productor.address).to receive(:assign_coordinates)

        productor.save

        expect(productor.address).to have_received(:assign_coordinates)
      end

      it 'does not fetch coordinates if coordinates are given' do
        productor.address = build :address, :coordinates
        allow(productor.address).to receive(:assign_coordinates)

        productor.save

        expect(productor.address).not_to have_received(:assign_coordinates)
      end
    end
  end

  context 'when a productor is updated' do
    let(:productor) { create :productor, address: build(:address, :coordinates) }

    before { allow(productor.address).to receive(:assign_coordinates) }

    context 'when its address is also updated,' do
      it 'fetches coordinates if no new coordinates are given' do
        new_address = attributes_for :address
        productor.update(address_attributes: new_address)
        expect(productor.address).to have_received(:assign_coordinates)
      end

      it 'fetches coordinates if empty coordinates are given' do
        new_address = attributes_for :address, coordinates: ['', '']
        productor.update(address_attributes: new_address)
        expect(productor.address).to have_received(:assign_coordinates)
      end

      it 'does not fetch new coordinates if new coordinates are given' do
        new_address = attributes_for :address, :coordinates
        productor.update(address_attributes: new_address)
        expect(productor.address).not_to have_received(:assign_coordinates)
      end
    end

    context 'when its address is not updated,' do
      it 'does not fetch coordinates' do
        productor.update(name: 'test')
        expect(productor.address).not_to have_received(:assign_coordinates)
      end
    end
  end

  context "when an address that doesn't belong to a productor is saved," do
    let(:address) { build :address, coordinates: nil }

    it "doesn't launch Address#assign_coordinates for a Member" do
      member = build :member
      member.address = address
      allow(member.address).to receive(:assign_coordinates)

      member.save

      expect(member.address).not_to have_received(:assign_coordinates)
    end

    it "doesn't launch Address#assign_coordinates for a Mission" do
      mission = build :mission
      mission.addresses << address
      allow(mission.addresses[0]).to receive(:assign_coordinates)

      mission.save

      expect(mission.addresses[0]).not_to have_received(:assign_coordinates)
    end
  end
end
