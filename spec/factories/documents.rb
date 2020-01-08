# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :document do
    trait :with_file do
      documents { fixture_file_upload(Rails.root.join('erd.pdf'), 'application/pdf') }
    end
  end
end
