FactoryBot.define do
  factory :participation do
    association :event, factory: :mission, event: true
    association :participant, factory: :member
  end
end
