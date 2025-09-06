# frozen_string_literal: true

FactoryBot.define do
  factory :documents_category, class: 'Documents::Category' do
    name { 'MyString' }
  end
end
