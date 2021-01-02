# frozen_string_literal: true

# This model keeps the selections of static slots by the members.
# It is used to prevent the abuses by the members.
class HistoryOfStaticSlotSelection < ApplicationRecord
  belongs_to :member
  belongs_to :static_slot
end
