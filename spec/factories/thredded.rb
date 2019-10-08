# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  sequence(:topic_hash) { |n| "hash#{n}" }

  factory :messageboard, class: Thredded::Messageboard do
    sequence(:name) { |n| "messageboard#{n}" }
    description { 'This is a description of the messageboard' }
  end

  factory :messageboard_group, class: Thredded::MessageboardGroup do
    sequence(:name) { |n| "#{Faker::Lorem.word} #{n}" }
  end

  factory :topic, class: Thredded::Topic do
    transient do
      with_posts { 0 }
      post_interval { 1.hour }
      with_categories { 0 }
    end

    title { Faker::Movies::StarWars.quote }
    hash_id { generate(:topic_hash) }

    association :user, factory: :member
    messageboard

    after(:create) do |topic, evaluator|
      if evaluator.with_posts
        ago = topic.updated_at - evaluator.with_posts * evaluator.post_interval
        evaluator.with_posts.times do
          ago += evaluator.post_interval
          create(:post, postable: topic, user: topic.user, messageboard: topic.messageboard, created_at: ago,
                        updated_at: ago, moderation_state: topic.moderation_state)
        end
        topic.last_user = topic.user
        topic.posts_count = evaluator.with_posts
        topic.save
      end

      evaluator.with_categories.times do
        topic.categories << create(:category)
      end
    end

    trait :locked do
      locked { true }
    end

    trait :pinned do
      sticky { true }
    end

    trait :sticky do
      sticky { true }
    end
  end

  factory :private_topic, class: Thredded::PrivateTopic do
    transient do
      with_posts { 0 }
      post_interval { 1.hour }
    end
    association :user, factory: :member
    users { [user] + build_list(:member, rand(1..3)) }

    title { Faker::Lorem.sentence[0..-2] }
    hash_id { generate(:topic_hash) }

    after :create do |topic, evaluator|
      if evaluator.with_posts
        ago = topic.updated_at - evaluator.with_posts * evaluator.post_interval
        last_user = nil
        evaluator.with_posts.times do |i|
          ago += evaluator.post_interval
          user = i == 0 ? topic.user : topic.users.sample
          last_user = user
          create(:private_post, postable: topic, user: user, created_at: ago, updated_at: ago)
        end
        topic.last_user = last_user
        topic.posts_count = evaluator.with_posts
        topic.save
      end
    end
  end

  factory :post, class: Thredded::Post do
    association :user, factory: :member
    postable { association :topic, user: user, last_user: user }

    content { FakeContent.post_content }

    after :build do |post|
      post.messageboard = post.postable.messageboard
    end
  end

  factory :private_post, class: Thredded::PrivatePost do
    association :user, factory: :member
    postable { association :private_topic, user: user, last_user: user }

    content { Faker::Hacker.say_something_smart }
  end

end
