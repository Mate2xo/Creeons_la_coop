# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean          default(FALSE)
#  category   :string           default("weekly_orders")
#

FactoryBot.define do
  factory :document do
    category factory: :documents_category
    date { Date.current }
    name { Faker::Game.title }
    file { Rack::Test::UploadedFile.new('spec/fixtures/files/erd.pdf', 'application/pdf') }
  end
end
