# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionPolicy, type: :policy do
  let(:member) { create :member }
  let(:admin) { create :member, :admin }
  let(:super_admin) { create :member, :super_admin }
  let(:mission) { create :mission }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :new?, :create?, :show? do
    it { is_expected.to permit member }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin }
  end

  permissions :edit?, :update?, :destroy? do
    it { is_expected.to permit member, create(:mission, author: member) }
    it { is_expected.not_to permit member, mission }

    it { is_expected.to permit admin, create(:mission, author: admin) }
    it { is_expected.not_to permit admin, mission }

    it { is_expected.to permit super_admin, mission }
  end
end
