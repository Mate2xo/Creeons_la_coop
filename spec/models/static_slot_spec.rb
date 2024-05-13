# frozen_string_literal: true

# == Schema Information
#
# Table name: static_slots
#
#  id         :bigint           not null, primary key
#  week_day   :integer          not null
#  start_time :datetime         not null
#  week_type  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe StaticSlot, type: :model do
  describe 'Model instanciation' do
    describe 'validations' do
      it { is_expected.to validate_presence_of(:week_day) }
      it { is_expected.to validate_presence_of(:start_time) }
      it { is_expected.to validate_presence_of(:week_type) }
    end

    describe 'associations' do
      it { is_expected.to have_many(:members).through(:member_static_slots) }
    end
  end
end
