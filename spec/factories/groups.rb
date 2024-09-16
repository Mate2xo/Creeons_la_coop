# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  roles      :string
#

FactoryBot.define do
  factory :group do
    name { Faker::Lorem.unique.word }

    trait :with_members_and_managers do
      group_managers { [association(:group_manager, managed_group: instance)] }
      group_members { [association(:group_member, group: instance)] }
    end
  end
end
