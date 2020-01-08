# frozen_string_literal: true

# == Schema Information
#
# Table name: infos
#
#  id         :bigint(8)        not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint(8)
#

FactoryBot.define do
  factory :info do
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    title { Faker::Movie.quote }
    association :author, factory: :member
  end
end
