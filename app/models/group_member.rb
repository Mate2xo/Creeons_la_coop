# frozen_string_literal: true

# join model of group management
class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :member
end
