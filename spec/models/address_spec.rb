# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:city).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:postal_code).of_type(:string) }
      it { is_expected.to have_db_column(:street_name_1).of_type(:string) }
      it { is_expected.to have_db_column(:street_name_2).of_type(:string) }
      it { is_expected.to have_db_column(:coordonnee).of_type(:string) }
      it { is_expected.to validate_presence_of(:city) }
    end

    describe 'associations' do
      let(:productor_address) {build_stubbed(:productor_address)}
      let(:member_address) {build_stubbed(:member_address)}
      let(:missions_address) {build_stubbed(:missions_address)}
      it { is_expected.to belong_to(:productor).optional }
      it { expect(productor_address.productor).to be_valid }
      it { is_expected.to belong_to(:member).optional }
      it { expect(member_address.member).to be_valid }
      it { is_expected.to have_and_belong_to_many(:missions) }
      it { expect(missions_address.missions).to be_valid }
    end
  end
  # TODO: #assign_coordonee
end
