# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistoryOfStaticSlotSelection, type: :model do
  it { is_expected.to belong_to(:static_slot) }
  it { is_expected.to belong_to(:member) }
end
