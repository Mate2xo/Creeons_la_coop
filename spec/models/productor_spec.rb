# frozen_string_literal: true

# == Schema Information
#
# Table name: productors
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  description  :text
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  website_url  :string
#  local        :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Productor, type: :model do
  describe "Model instanciation" do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:phone_number).of_type(:string) }
      it { is_expected.to have_db_column(:website_url).of_type(:string) }
      it { is_expected.to validate_presence_of(:name).on(:create) }
      it { is_expected.to validate_uniqueness_of(:name) }
    end

    describe 'associations' do
      it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
      it { is_expected.to have_one(:address).dependent(:destroy) }
      it { is_expected.to have_and_belong_to_many(:missions).dependent(:nullify) }
      it { is_expected.to have_and_belong_to_many(:managers).class_name('Member').dependent(:nullify) }
    end
  end
end
