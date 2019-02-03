# frozen_string_literal: true

require 'rails_helper'

# Visitor access is tested in matching controllers
RSpec.describe InfoPolicy, type: :policy do
  let(:member) { build(:member) }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    it "allows access to any member" do
      expect(subject).to permit member
    end
  end

  permissions :create? do
    it "denies access to a regular member" do
      expect(subject).not_to permit member
    end

    it "allows access to an admin" do
      member.role = "admin"
      expect(subject).to permit(member)
    end

    it "allows access to an super_admin" do
      member.role = "super_admin"
      expect(subject).to permit(member)
    end
  end

  permissions :update? do
    it "denies access to a regular member" do
      expect(subject).not_to permit member
    end

    it "allows access to an admin" do
      member.role = "admin"
      expect(subject).to permit(member)
    end

    it "allows access to an super_admin" do
      member.role = "super_admin"
      expect(subject).to permit(member)
    end
  end

  permissions :destroy? do
    it "denies access to a regular member" do
      expect(subject).not_to permit member
    end

    it "denies access to an admin" do
      member.role = "admin"
      expect(subject).not_to permit(member)
    end

    it "allows access to an super_admin" do
      member.role = "super_admin"
      expect(subject).to permit(member)
    end
  end
end
