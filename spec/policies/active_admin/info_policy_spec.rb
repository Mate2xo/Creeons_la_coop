# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveAdmin::InfoPolicy, type: :policy do
  subject { described_class }

  let(:member) { build(:member) }
  let(:admin) { build_stubbed :member, :admin }
  let(:super_admin) { build_stubbed :member, :super_admin }
  let(:redactor) { create :member, redactor?: true }

  permissions :index?, :show?, :new?, :create?, :edit?, :update?, :destroy? do
    it { is_expected.not_to permit member }
    it { is_expected.to permit redactor }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin }
  end
end
