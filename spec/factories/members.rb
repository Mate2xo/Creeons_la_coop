# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                        :bigint(8)        not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  first_name                :string
#  last_name                 :string
#  biography                 :text
#  phone_number              :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  role                      :integer          default("member")
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  unconfirmed_email         :string
#  invitation_token          :string
#  invitation_created_at     :datetime
#  invitation_sent_at        :datetime
#  invitation_accepted_at    :datetime
#  invitation_limit          :integer
#  invited_by_type           :string
#  invited_by_id             :bigint(8)
#  invitations_count         :integer          default(0)
#  display_name              :string
#  moderator                 :boolean          default(FALSE)
#  cash_register_proficiency :integer          default("untrained")
#

FactoryBot.define do
  factory :member do
    transient do
      redactor? { false }
    end

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    biography { Faker::ChuckNorris.fact }
    phone_number { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email(name: first_name) }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.today }

    trait :admin do role { 'admin' } end
    trait :super_admin do role { 'super_admin' } end

    after :create do |member, options|
      if options.redactor?
        group = create :group, roles: ['redactor']
        GroupMember.create(member: member, group: group)
      end
    end
  end
end
