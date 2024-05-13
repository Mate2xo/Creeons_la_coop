# frozen_string_literal: true

# Join model between a Group and its managing Member
class GroupManager < ApplicationRecord
  belongs_to :managed_group, class_name: :Group
  belongs_to :manager, class_name: :Member
end
