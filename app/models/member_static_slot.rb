# frozen_string_literal: true

# join model
class MemberStaticSlot < ApplicationRecord
  belongs_to :member
  belongs_to :static_slot
end
