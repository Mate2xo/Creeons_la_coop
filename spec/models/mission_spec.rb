# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mission, type: :model do
  let(:mission) { build(:mission) }
  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: false) }
      it { is_expected.to have_db_column(:due_date).of_type(:datetime) }
      it { is_expected.to have_db_column(:min_member_count).of_type(:integer) }
      it { is_expected.to have_db_column(:max_member_count).of_type(:integer) }
      it { is_expected.to have_db_index(:author_id) }
    end

    describe 'validations' do
      it { is_expected.to accept_nested_attributes_for(:addresses).allow_destroy(true) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:max_member_count) }
      it { is_expected.to validate_presence_of(:min_member_count) }
    end

    describe 'associations' do
      it { is_expected.to belong_to(:author).class_name('Member').inverse_of('created_missions') }
      it { is_expected.to have_and_belong_to_many(:members) }
      it { is_expected.to have_and_belong_to_many(:productors) }
      it { is_expected.to have_and_belong_to_many(:addresses) }
    end
  end
end
