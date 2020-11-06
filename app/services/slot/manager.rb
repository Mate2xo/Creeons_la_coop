# frozen_string_literal: true

# It Generate slot after a mission creation
class Slot::Manager < ApplicationService
  attr_reader :errors

  def initialize(mission_id, member_id, start_times)
    @mission_id = mission_id
    @member_id = member_id
    @start_times = start_times.map(&:to_datetime) unless start_times.nil?
    @errors = []
  end

  def manage
    update_slots_in_order_to_remove_these_from_member
    update_slots_in_order_to_give_these_to_member
    return false if @errors.any?

    true
  end

  def update_slots_in_order_to_remove_these_from_member
    deselected_slots = Mission::Slot.where(member_id: @member_id, mission_id: @mission_id).where.not(start_time: @start_times)
    deselected_slots.each do |slot|
      slot.update(member_id: nil) || @errors << slot.update_errors.full_messages.join(', ')
    end
  end

  def update_slots_in_order_to_give_these_to_member
    return if @start_times.nil?

    @start_times.each do |start_time|
      give_a_slot_with_a_start_time(start_time) unless start_time_already_selected?(start_time)
    end
  end

  def start_time_already_selected?(start_time)
    return false if Mission::Slot.find_by(mission_id: @mission_id, member_id: @member_id, start_time: start_time).nil?

    true
  end

  def give_a_slot_with_a_start_time(start_time)
    slot = Mission::Slot.find_by(mission_id: @mission_id, member_id: nil, start_time: start_time)
    if slot.present?
      slot.update(member_id: @member_id)
      @errors << slot.errors.full_messages.join(', ') if slot.errors.present?
    else
      @errors << I18n.t('activerecord.errors.slot.unavailability', start_time: start_time)
    end
  end
end
