require 'rails_helper'

RSpec.describe GroupMember, type: :model do
  it { is_expected.to belong_to(:member) }
  it { is_expected.to belong_to(:group) }
end
