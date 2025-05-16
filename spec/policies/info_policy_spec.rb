# frozen_string_literal: true

require 'rails_helper'

# Visitor access is tested in matching controllers
RSpec.describe InfoPolicy, type: :policy do
  subject { described_class }

  let(:member) { build(:member) }
  let(:admin) { build(:member, :admin) }
  let(:super_admin) { build(:member, :super_admin) }

  permissions :index?, :show? do
    it { is_expected.to permit member }
  end

  permissions :create?, :update? do
    it { is_expected.not_to permit member }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin }
  end

  permissions :destroy? do
    let(:info) { build(:info) }

    it { is_expected.not_to permit member, info }
    it { is_expected.not_to permit admin, info }
    it { is_expected.to permit super_admin, info }

    context 'with an info authored by the current user' do
      let(:info) { build(:info, author: member) }

      it { is_expected.to permit member, info }
    end
  end

  describe '.scope' do
    subject(:scope) do
      create(:info)
      create(:info, published: true)
      described_class::Scope.new user, Info
    end

    let(:user) { nil }

    it 'fetches only published infos' do
      expect(scope.resolve.count).to eq 1
    end

    context 'with a member' do
      let(:user) { build_stubbed(:member) }

      it 'fetches all infos' do
        expect(scope.resolve.count).to eq 2
      end
    end
  end
end
