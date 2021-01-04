# frozen_string_literal: true

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
