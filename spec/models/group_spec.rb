# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                       :bigint(8)        not null, primary key
#  name                     :string           not null
#  group_manager_mail       :string

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:group_manager_mail).of_type(:string) }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { validate_uniqueness_of(:name).case_insensitive }
    end

    describe 'associations' do
      it { is_expected.to have_many(:members).through(:group_members) }
    end
  end
end
