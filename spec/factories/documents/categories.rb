# frozen_string_literal: true

FactoryBot.define do
  factory :documents_category, class: 'Documents::Category' do
    sequence(:name) { |i| "Category nª#{i}" }
  end
end
