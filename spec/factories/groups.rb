FactoryBot.define do
  factory :group do
    name { Faker::Lorem.word }

    trait :with_group_manager_mail do
      group_manager_mail { Member.all.sample.email }
    end
  end
end
