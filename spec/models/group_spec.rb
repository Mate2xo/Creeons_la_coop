# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  roles      :string
#

require 'rails_helper'

RSpec.describe Group do
  describe 'validations' do
    subject(:instance) { build(:group) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:members).through(:group_members) }

    it 'has many managers' do
      expect(subject)
        .to have_many(:managers)
        .class_name('Member')
        .inverse_of('managed_groups')
        .through(:group_managers)
    end
  end
end
