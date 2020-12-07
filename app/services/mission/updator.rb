# frozen_string_literal: true

# It updates slots before a mission update
class Mission::Updator < ApplicationService
  def initialize(mission, params)
    @params = params
    @mission = mission
    @new_start_date = params[:start_date].presence || mission.start_date
    @new_start_date = @new_start_date.to_datetime
    @new_due_date = params[:due_date].presence || mission.due_date
    @new_due_date = @new_due_date.to_datetime
    @new_duration = @new_due_date.to_i - @new_start_date.to_i
    @new_max_member_count = params[:max_member_count].presence || mission.max_member_count
    @new_max_member_count = @new_max_member_count.to_i
    @new_event_status = params[:event].presence || mission.event
    @new_event_status = ActiveRecord::Type::Boolean.new.cast(@new_event_status)
    @errors = []
  end

  def call
    response = @mission.update(@params) if @mission.event && @new_event_status
    response = transform_to_event if !@mission.event && @new_event_status
    response = transform_to_mission if @mission.event && !@new_event_status
    response = update_mission if !@mission.event && !@new_event_status
    response
  end

  def transform_to_event
    Mission::Slot.transaction do
      @mission.slots.destroy_all
      @mission.update!(@params)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def transform_to_mission
    Mission::Slot.transaction do
      @mission.participations.destroy_all
      @mission.update!(@params)
      ::Slot::Generator.call(@mission.reload)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update_mission
    Mission::Slot.transaction do
      update_start_times if @new_start_date != @mission.start_date
      add_new_slots_in_order_to_cover_new_max_member_count if @new_max_member_count > @mission.max_member_count
      remove_slots_according_the_reduction_of_max_member_count if @new_max_member_count < @mission.max_member_count
      add_new_slots_in_order_to_cover_new_duration if @new_duration > @mission.duration
      remove_useless_slots if @new_duration < @mission.duration
      @mission.update!(@params)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update_start_times
    @mission.slots.each do |slot|
      difference_between_dates = @new_start_date.to_i - @mission.start_date.to_i
      slot.update!(start_time: (slot.start_time + difference_between_dates))
    end
  end

  def add_new_slots_in_order_to_cover_new_max_member_count
    difference_between_max_members_count = @new_max_member_count - @mission.max_member_count
    start_times = Mission::Slot.where(mission_id: @mission.id).order(:start_time).group(:start_time).count.keys
    start_times.each do |start_time|
      difference_between_max_members_count.times do
        Mission::Slot.create!(mission_id: @mission.id, start_time: start_time)
      end
    end
  end

  def check_availibility_for_remove
    difference_between_max_members_count = @mission.max_member_count - @new_max_member_count
    available_slots_by_time_slot = Mission::Slot.where(mission_id: @mission.id, member_id: nil)
                                                .order(:start_time)
                                                .group(:start_time)
                                                .count

    check = available_slots_by_time_slot.all? { |_key, count| count >= difference_between_max_members_count }
    @errors.push(t('missions.errors.max_members_count.impossibility_of_reducing')) unless check
    check
  end

  def remove_slots_according_the_reduction_of_max_member_count
    return unless check_availibility_for_remove

    difference_between_max_members_count = @mission.max_member_count - @new_max_member_count
    time_slots = Mission::Slot.where(mission_id: @mission.id, member_id: nil)
                              .order(:start_time)
                              .group(:start_time)
                              .count
                              .keys

    time_slots.each do |time_slot|
      slots = Mission::Slot.where(mission_id: @mission.id, member_id: nil, start_time: time_slot)
      difference_between_max_members_count.times do |n|
        slots[n].destroy
      end
    end
  end

  def add_new_slots_in_order_to_cover_new_duration
    difference_between_durations = @new_duration - @mission.duration
    time_slots_difference = (difference_between_durations / 60 / 90).to_int

    time_slots_difference.times do
      last_start_time = Mission::Slot.where(mission_id: @mission.id)
                                     .order(:start_time).group(:start_time).count.keys.last
      @new_max_member_count.times do
        Mission::Slot.create!(mission_id: @mission.id, start_time: (last_start_time + 90.minutes))
      end
    end
  end

  def remove_useless_slots
    difference_between_durations = @mission.duration - @new_duration
    time_slots_difference = (difference_between_durations / 60 / 90).to_int

    time_slots_difference.times do
      last_start_time = Mission::Slot.where(mission_id: @mission.id)
                                     .order(:start_time).group(:start_time).count.keys.last
      @new_max_member_count.times do
        Mission::Slot.find_by(mission_id: @mission.id, start_time: last_start_time).destroy
      end
    end
  end
end
