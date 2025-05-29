# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe ActiveAdmin::GroupPolicy, type: :policy do
  subject { described_class }

  permissions :index?, :create?, :destroy?, :edit?, :show?, :update? do
    it { is_expected.to permit build(:member, :super_admin) }
    it { is_expected.not_to permit build(:member, :admin) }
    it { is_expected.not_to permit build(:member) }
  end
end
