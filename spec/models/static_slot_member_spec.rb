require 'rails_helper'

RSpec.describe StaticSlotMember, type: :model do
  it { is_expected.to belong_to(:static_slot) }
  it { is_expected.to belong_to(:member) }
end
