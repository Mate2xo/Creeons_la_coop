# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe ProductorPolicy, type: :policy do
  subject { described_class }

  let(:member) { build(:member) }
  let(:admin) { build(:member, :admin) }
  let(:super_admin) { build(:member, :super_admin) }

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show?, :index? do
    it { is_expected.to permit member }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin }
  end

  permissions :create?, :update? do
    it { is_expected.not_to permit member }
    it { is_expected.to permit admin }
    it { is_expected.to permit super_admin }
  end

  permissions :destroy? do
    let(:productor) { build(:productor) }

    it { is_expected.not_to permit member }
    it { is_expected.not_to permit admin, productor }

    it 'allows access to the productor manager (admin)' do
      productor.managers << admin
      expect(subject).to permit(admin, productor)
    end

    it { is_expected.to permit super_admin }
  end
end
