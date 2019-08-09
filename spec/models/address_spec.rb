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
      it { is_expected.to have_db_column(:coordinates).of_type(:string) }
      it { is_expected.to validate_presence_of(:city) }
    end

    describe 'associations' do
      let(:productor_address) { build_stubbed(:productor_address) }
      let(:member_address) { build_stubbed(:member_address) }
      let(:missions_address) { create(:missions_address) }
      it { is_expected.to belong_to(:productor).optional }
      it { expect(productor_address.productor).to be_valid }
      it { is_expected.to belong_to(:member).optional }
      it { expect(member_address.member).to be_valid }
      it { is_expected.to have_and_belong_to_many(:missions) }
      it { expect(missions_address.missions).to be_truthy }
    end
  end
  # TODO: #assign_coordonee
end
