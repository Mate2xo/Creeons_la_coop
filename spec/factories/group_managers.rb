# frozen_string_literal: true

FactoryBot.define do
  factory :group_manager do
    managed_group factory: :group
    manager factory: :member
  end
end
