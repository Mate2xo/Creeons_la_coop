require 'rails_helper'

RSpec.describe StaticSlot, type: :model do
  describe 'Model instanciation' do
    describe 'validations' do
      it { is_expected.to validate_presence_of(:week_day) }
      it { is_expected.to validate_presence_of(:hours) }
      it { is_expected.to validate_presence_of(:week_type) }
    end

    describe 'associations' do
      it { is_expected.to have_many(:members).through(:static_slot_member) }
    end
  end
end
