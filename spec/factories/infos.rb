# frozen_string_literal: true

# == Schema Information
#
# Table name: infos
#
#  id         :bigint           not null, primary key
#  category   :string
#  content    :text
#  published  :boolean          default(FALSE)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint
#
# Indexes
#
#  index_infos_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => members.id)
#

FactoryBot.define do
  factory :info do
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    title { Faker::Movie.quote }
    association :author, factory: :member
  end
end
