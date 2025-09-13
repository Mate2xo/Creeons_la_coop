# frozen_string_literal: true

# == Schema Information
#
# Table name: documents_categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_documents_categories_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :documents_category, class: 'Documents::Category' do
    sequence(:name) { |i| "Category nª#{i}" }
  end
end
