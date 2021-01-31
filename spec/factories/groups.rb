# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                       :bigint(8)        not null, primary key
#  name                     :string           not null
#  roles                    :array[string]
#  group_manager_mail       :string

FactoryBot.define do
  factory :group do
    name { Faker::Lorem.word }
  end
end
