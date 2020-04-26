# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionPolicy, type: :policy do
  subject { described_class }

  let(:member) { build_stubbed :member }
  let(:admin) { build_stubbed :member, :admin }
  let(:super_admin) { build_stubbed :member, :super_admin }
  let(:any_mission) { build_stubbed :mission }

  permissions :new?, :create?, :show? do
    it { is_expected.to permit member }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin }
  end

  permissions :destroy? do
    it { is_expected.to permit member, build_stubbed(:mission, author: member) }
    it { is_expected.not_to permit member, any_mission }

    it { is_expected.to permit admin, build_stubbed(:mission, author: admin) }
    it { is_expected.not_to permit admin, any_mission }

    it { is_expected.to permit super_admin, any_mission }
  end
end
