# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveAdmin::CommentPolicy, type: :policy do
  let(:member) { build :member }
  let(:admin) { build :member, :admin }
  let(:super_admin) { build :member, :super_admin }
  let(:comment) { ActiveAdmin::Comment.new }

  subject { described_class }

  permissions ".scope" do
    pending "admin interface resources access is yet to be decided"
  end

  permissions :show?, :create?, :update?, :destroy? do
    it { is_expected.to permit super_admin, comment }
    it { is_expected.not_to permit admin, comment }
    it { is_expected.not_to permit member, comment }
  end
end
