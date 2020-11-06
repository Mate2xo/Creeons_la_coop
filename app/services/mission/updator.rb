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
    @new_duration = @new_due_date - @new_start_date
    @new_max_member_count = params[:max_member_count].presence || mission.max_member_count
    @new_event_status = params[:event].presence || mission.event
  end

  def call
    response = @mission.update(@params) if @mission.event && @new_event_status
    response = transform_to_event if @mission.event == false && @new_event_status
    response = transform_to_mission if @mission.event && @new_event_status == false
    response = update_mission if @mission.event == false && @new_event_status == false
    response
  end

  def transform_to_event
    all_is_ok = true
    Mission::Slot.transaction do
      @mission.slots.destroy_all
      @mission.update!(@params)
    rescue ActiveRecord::RecordInvalid
      all_is_ok = false
    end
    all_is_ok
  end

  def transform_to_mission
    all_is_ok = true
    Mission::Slot.transaction do
      @mission.participations.destroy_all
      @mission.update!(@params)
      Slot::Generator(@mission.reload)
    rescue ActiveRecord::RecordInvalid
      all_is_ok = false
    end
    all_is_ok
  end

  def update_mission
    all_is_ok = true
    Mission::Slot.transaction do
      update_start_times if @new_start_date != @mission.start_date
      add_new_slots_in_order_to_cover_new_max_member_count if @new_max_member_count != @mission.max_member_count
      add_new_slots_in_order_to_cover_new_duration if @new_duration > @mission.duration
      remove_useless_slots if @new_duration < @mission.duration
      @mission.update!(@params)
    rescue ActiveRecord::RecordInvalid
      all_is_ok = false
    end
    all_is_ok
  end

  def update_start_times
    @mission.slots.each do |slot|
      difference_between_dates = @new_start_date.to_datetime - @mission.start_date.to_datetime
      slot.update!(start_time: (slot.start_time.to_datetime + difference_between_dates))
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

  def add_new_slots_in_order_to_cover_new_duration
    difference_between_durations = @new_duration - mission.duration
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
        Mission::Slot.delete(mission_id: @mission.id, start_time: last_start_time)
      end
    end
  end
end
