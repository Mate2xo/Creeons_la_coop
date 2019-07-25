# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  biography              :text
#  phone_number           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string           default("member")
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#

FactoryBot.define do
  factory :member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    biography { Faker::ChuckNorris.fact }
    phone_number { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email(first_name) }
    group { ['aucun', 'informatique', 'communication', 'étude'].sample }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.today }

    trait :admin do role { 'admin' } end
    trait :super_admin do role { 'super_admin' } end
  end
end
