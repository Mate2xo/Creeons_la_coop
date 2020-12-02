# frozen_string_literal: true

class MissionDecorator < Draper::Decorator # rubocop:disable Style/Documentation
  delegate_all

  def time_slots_selection_for_current_member
    object.slots.where('member_id IS ? OR member_id = ?', nil, h.current_member.id).group(:start_time).count.keys.reverse
  end

  def time_slot_is_already_selected?(slot_time)
    object.slots.where(member_id: h.current_member.id, start_time: slot_time).present?
  end
end
