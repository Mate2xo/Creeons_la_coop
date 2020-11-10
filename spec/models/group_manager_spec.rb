require 'rails_helper'

RSpec.describe GroupManager, type: :model do
  it { is_expected.to belong_to(:manager).class_name('Member') }
  it { is_expected.to belong_to(:managed_group).class_name('Group') }
end
