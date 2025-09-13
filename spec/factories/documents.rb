# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id          :bigint           not null, primary key
#  category    :string           default("weekly_orders")
#  date        :date
#  name        :string
#  published   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_documents_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => documents_categories.id)
#

FactoryBot.define do
  factory :document do
    category factory: :documents_category
    date { Date.current }
    name { Faker::Game.title }
    file { Rack::Test::UploadedFile.new('spec/fixtures/files/erd.pdf', 'application/pdf') }
  end
end
