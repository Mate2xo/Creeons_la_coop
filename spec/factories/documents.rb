# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# rubocop:disable Style/MixinUsage
include ActionDispatch::TestProcess::FixtureFile
# rubocop:enable Style/MixinUsage

FactoryBot.define do
  factory :document do
    trait :with_file do
      file { fixture_file_upload(Rails.root.join('spec', 'support', 'fixtures', 'erd.pdf'), 'application/pdf') }
    end
  end
end
