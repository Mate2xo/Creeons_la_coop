# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberPolicy, type: :policy do
  let(:member) { build(:member) }
  let(:other_member) { create(:member) }
  let(:admin) { build :member, :admin }
  let(:super_admin) { build :member, :super_admin }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show?, :index? do
    it { is_expected.to permit member, other_member }
    it { is_expected.to permit admin, other_member }
    it { is_expected.to permit super_admin, other_member }
  end

  permissions :create? do
    it { is_expected.not_to permit member, other_member }
    it { is_expected.not_to permit admin, other_member }
    it { is_expected.to permit super_admin, other_member }
  end

  permissions :update? do
    it { is_expected.to permit member, member }
    it { is_expected.not_to permit member, other_member }

    it { is_expected.to permit admin, admin }
    it { is_expected.not_to permit admin, other_member }

    it { is_expected.to permit super_admin, super_admin }
  end

  permissions :destroy? do

    it { is_expected.not_to permit member }
    it { is_expected.not_to permit admin, other_member }
    it { is_expected.to permit super_admin }
  end
end
