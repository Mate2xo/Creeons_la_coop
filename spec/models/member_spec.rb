# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:id).of_type(:integer) }
      it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:first_name).of_type(:string) }
      it { is_expected.to have_db_column(:last_name).of_type(:string) }
      it { is_expected.to have_db_column(:biography).of_type(:text) }
      it { is_expected.to have_db_column(:phone_number).of_type(:string) }
      it { is_expected.to have_db_column(:role).of_type(:string).with_options(default: 'user') }
      it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
      it { is_expected.to have_db_index(:confirmation_token) }
      it { is_expected.to have_db_index(:email).unique }
      it { is_expected.to have_db_index(:reset_password_token).unique }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
    end

    describe 'associations' do
      it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
      it { is_expected.to have_one(:address).dependent(:destroy) }
      it { is_expected.to have_many(:created_missions).class_name('Mission').with_foreign_key('author_id').dependent(:nullify) }
      it { is_expected.to have_and_belong_to_many(:missions).dependent(:nullify) }
    end
  end
end