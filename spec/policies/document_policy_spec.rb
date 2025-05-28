# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentPolicy, type: :policy do
  subject { described_class }

  let(:member) { build(:member) }
  let(:admin) { build(:member, :admin) }
  let(:super_admin) { build(:member, :super_admin) }

  permissions '.scope' do
  end

  permissions :create?, :destroy? do
    it 'does not allows members to upload' do
      expect(subject).not_to permit(member)
    end

    it 'allows admins to upload' do
      expect(subject).to permit(admin)
    end

    it 'allows super_admins to upload' do
      expect(subject).to permit(super_admin)
    end
  end
end
