# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveAdmin::DocumentPolicy, type: :policy do
  subject { described_class }

  permissions :index?, :create?, :show?, :edit?, :update? do
    it { is_expected.to permit build(:member, :super_admin) }
    it { is_expected.to permit build(:member, :admin) }
    it { is_expected.not_to permit build(:member) }
  end

  permissions :destroy? do
    it { is_expected.to permit build(:member, :super_admin) }
    it { is_expected.not_to permit build(:member, :admin) }
    it { is_expected.not_to permit build(:member) }
  end
end
