# frozen_string_literal: true

# join model of group management
class GroupManager < ApplicationRecord
  belongs_to :managed_group, class_name: :Group
  belongs_to :manager, class_name: :Member
end
