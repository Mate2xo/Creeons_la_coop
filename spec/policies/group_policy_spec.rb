# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe GroupPolicy, type: :policy do
  subject { described_class }

  permissions :index?, :show? do
    it { is_expected.to permit build_stubbed(:member) }
  end

  permissions :create?, :destroy?, :update? do
    it { is_expected.to permit build_stubbed(:member, :super_admin) }
    it { is_expected.not_to permit build_stubbed(:member, :admin) }
    it { is_expected.not_to permit build_stubbed(:member) }
  end
end
