# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                        :bigint           not null, primary key
#  biography                 :text
#  cash_register_proficiency :integer          default("untrained")
#  confirmation_sent_at      :datetime
#  confirmation_token        :string
#  confirmed_at              :datetime
#  display_name              :string
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  first_name                :string
#  invitation_accepted_at    :datetime
#  invitation_created_at     :datetime
#  invitation_limit          :integer
#  invitation_sent_at        :datetime
#  invitation_token          :string
#  invitations_count         :integer          default(0)
#  invited_by_type           :string
#  last_name                 :string
#  moderator                 :boolean          default(FALSE)
#  phone_number              :string
#  remember_created_at       :datetime
#  reset_password_sent_at    :datetime
#  reset_password_token      :string
#  role                      :integer          default("member")
#  unconfirmed_email         :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  invited_by_id             :bigint
#  register_id               :integer
#
# Indexes
#
#  index_members_on_confirmation_token                 (confirmation_token)
#  index_members_on_email                              (email) UNIQUE
#  index_members_on_invitation_token                   (invitation_token) UNIQUE
#  index_members_on_invitations_count                  (invitations_count)
#  index_members_on_invited_by_id                      (invited_by_id)
#  index_members_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_members_on_reset_password_token               (reset_password_token) UNIQUE
#  members_display_name_lower                          (lower((display_name)::text) text_pattern_ops) UNIQUE
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
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { Time.zone.today }

    trait :admin do
      role { 'admin' }
    end
    trait :super_admin do
      role { 'super_admin' }
    end
    trait :beginner do
      cash_register_proficiency { :beginner }
    end

    after :create do |member, options|
      if options.redactor?
        group = create(:group, roles: ['redactor'])
        GroupMember.create(member: member, group: group)
      end
    end
  end
end
