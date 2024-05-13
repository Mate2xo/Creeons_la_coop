# frozen_string_literal: true

# Join model between a Group and a regular Member
class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :member
end
