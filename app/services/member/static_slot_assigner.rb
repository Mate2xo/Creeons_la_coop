# frozen_string_literal: true

# It updates slots before a mission update
class Member::StaticSlotAssigner < ApplicationService # rubocop:disable Style/ClassAndModuleChildren
  def initialize(current_member, static_slot_params)
    @current_member = current_member
    @static_slot_ids = extract_ids(static_slot_params)

    @errors = []
  end

  def call
    @static_slot_ids.each do |static_slot_id|
      ::StaticSlotMember.create(member_id: @current_member.id, static_slot_id: static_slot_id)
    end
  end

  private

  def extract_ids(static_slot_params)
    static_slot_ids = []
    static_slot_params.values.each do |value|
      static_slot_ids << value['id']
    end
    static_slot_ids
  end
end
