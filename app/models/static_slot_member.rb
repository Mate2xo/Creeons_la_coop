# frozen_string_literal: true

# join model
class StaticSlotMember < ApplicationRecord
  belongs_to :member
  belongs_to :static_slot
end
