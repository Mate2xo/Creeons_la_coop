# frozen_string_literal: true

# == Schema Information
#
# Table name: documents_sub_categories
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_documents_sub_categories_on_category_id           (category_id)
#  index_documents_sub_categories_on_name_and_category_id  (name,category_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => documents_categories.id)
#
FactoryBot.define do
  factory :documents_sub_category, class: 'Documents::SubCategory' do
    sequence(:name) { |i| "SubCategory nª#{i}" }
    category factory: :documents_category
  end
end
