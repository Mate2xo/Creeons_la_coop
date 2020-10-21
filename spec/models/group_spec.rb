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

    describe 'validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { validate_uniqueness_of(:name).case_insensitive }
    end

    describe 'associations' do
      it { is_expected.to have_many(:members).through(:group_members) }
      it { is_expected.to have_many(:managers).class_name('Member').inverse_of('managed_groups').through(:group_managers) }
    end
  end
end
