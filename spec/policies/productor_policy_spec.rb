# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductorPolicy, type: :policy do
  let(:member) { build(:member) }
  let(:admin) { build :member, :admin }
  let(:super_admin) { build :member, :super_admin }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    it { is_expected.to permit member }
  end

  permissions :create?, :update? do
    it { is_expected.not_to permit member }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin}
  end

  permissions :destroy? do
    let(:productor) { build(:productor) }

    it { is_expected.not_to permit member }
    it { is_expected.not_to permit admin }

    it "allows access to the productor manager (admin)" do
      skip
      productor.managers << admin
      expect(subject).to permit(admin)
    end

    it { is_expected.to permit super_admin }
  end
end
