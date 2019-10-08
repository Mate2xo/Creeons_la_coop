# frozen_string_literal: true

# == Schema Information
#
# Table name: productors
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  description  :text
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  website_url  :string
#  local        :boolean          default(FALSE)
#

FactoryBot.define do
  factory :productor do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    phone_number { Faker::PhoneNumber.phone_number }
    website_url { Faker::Internet.url(host: "#{name}.com") }
  end
end
