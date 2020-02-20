# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentPolicy, type: :policy do
  let(:member) { build :member }
  let(:admin) { build :member, :admin }
  let(:super_admin) { build :member, :super_admin }

  subject { described_class }

  permissions ".scope" do
  end

  permissions :create?, :destroy? do
    it "does not allows members to upload" do
      is_expected.not_to permit(member)
    end

    it "allows admins to upload" do
      is_expected.to permit(admin)
    end

    it "allows super_admins to upload" do
      is_expected.to permit(super_admin)
    end
  end
end
