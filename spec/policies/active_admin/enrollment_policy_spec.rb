# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveAdmin::EnrollmentPolicy, type: :policy do
  subject { described_class }

  let(:member) { build(:member) }
  let(:admin) { build :member, :admin }
  let(:super_admin) { build :member, :super_admin }

  permissions :index?, :show?, :new?, :create?, :edit?, :update?, :destroy? do
    it { is_expected.not_to permit member }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin }
  end
end
