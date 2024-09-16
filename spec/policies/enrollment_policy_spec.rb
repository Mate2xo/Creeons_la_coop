# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnrollmentPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions '.scope' do
    subject(:scope) { described_class::Scope.new(nil, Enrollment).resolve }

    it 'returns everything' do
      allow(Enrollment).to receive(:all)
      scope
      expect(Enrollment).to have_received(:all)
    end
  end

  permissions :index?, :show?, :create?, :update?, :destroy? do
    it { is_expected.to permit }
  end
end
