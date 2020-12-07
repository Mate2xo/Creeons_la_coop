# frozen_string_literal: true

# It assigns or remove assignement of slots to members
class Slot::Assigner < ApplicationService
  attr_reader :errors

  def initialize(mission_id, member_id, start_times)
    @mission_id = mission_id
    @member_id = member_id
    @start_times = start_times.map(&:to_datetime) unless start_times.nil?
    @errors = []
  end

  def assign
    all_is_ok = true
    Mission::Slot.transaction do
      update_slots_in_order_to_remove_these_from_member
      update_slots_in_order_to_give_these_to_member
      if @errors.any?
        all_is_ok = false
        raise ActiveRecord::Rollback
      end
    end

    all_is_ok
  end

  def update_slots_in_order_to_remove_these_from_member
    deselected_slots = Mission::Slot.where(member_id: @member_id, mission_id: @mission_id)
                                    .where.not(start_time: @start_times)
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
    if slot.nil?
      @errors << I18n.t('activerecord.errors.models.slot.messages.unavailability', start_time: start_time)
      return
    end

    slot.update(member_id: @member_id)
    @errors << slot.errors.full_messages.join(', ') if slot.errors.present?
  end
end
