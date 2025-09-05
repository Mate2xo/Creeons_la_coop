# frozen_string_literal: true

require 'rails_helper'
require 'pundit/rspec'

RSpec.describe DocumentPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:member) { build(:member) }
  let(:admin) { build(:member, :admin) }
  let(:super_admin) { build(:member, :super_admin) }

  permissions :create?, :destroy? do
    it 'does not allows members to upload' do
      expect(policy).not_to permit(member)
    end

    it 'allows admins to upload' do
      expect(policy).to permit(admin)
    end

    it 'allows super_admins to upload' do
      expect(policy).to permit(super_admin)
    end
  end

  permissions '.scope' do
    subject(:scope) do
      create(:document, published: true)
      create(:document, published: false)
      described_class::Scope.new(member, Document)
    end

    context 'with a member' do
      let(:member) { create(:member) }

      it 'returns all documents' do
        expect(scope.resolve.count).to eq 2
      end
    end

    context 'without a member' do
      let(:member) { nil }

      it 'returns only published documents' do
        expect(scope.resolve.count).to eq 1
      end
    end
  end
end
