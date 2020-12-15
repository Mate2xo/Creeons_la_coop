# frozen_string_literal: true

# It enroll members with static slots to the related missions
class StaticMembersRecruiter < ApplicationService # rubocop:disable Style/ClassAndModuleChildren
  def initialize
    @errors = []
    @static_slots = StaticSlot.all
    @members_with_static_slots = Member.all.select { |member| member.static_slots.any? }
    @current_time = DateTime.current
  end

  def call
    enrollments_for_all_members
  end

  def enrollments_for_all_members
    @members_with_static_slots.each do |member|
      enrollment_for_one_member(member)
    end
  end

  def enrollment_for_one_member(member)
    member.static_slots.each do |static_slot|
      unless already_enrolled_for_this_time_slot?(member, static_slot)
        enrollments_for_one_static_slot(member, static_slot)
      end
    end
  end

  def enrollments_for_one_static_slot(member, static_slot)
    mission_slots = search_mission_slots_corresponding_to_static_slot(static_slot)
    mission_slots.each do |mission_slot|
      mission_slot.update(member_id: member.id) unless already_enrolled_for_this_time_slot?(member, mission_slot)
    end
  end

  def search_mission_slots_corresponding_to_static_slot(static_slot)
    mission_slots = []
    start_time = determine_first_start_time_corresponding_to_static_slot_after_current_date(static_slot)
    mission_slots << Mission::Slot.find_by(start_time: start_time, member_id: nil)
    mission_slots << Mission::Slot.find_by(start_time: start_time + 4.weeks, member_id: nil)
    mission_slots.compact
  end

  def determine_first_start_time_corresponding_to_static_slot_after_current_date(static_slot)
    first_start_time = @current_time + determine_intervals_with_current_time(static_slot)
    first_start_time = DateTime.new(first_start_time.year,
                                    first_start_time.month,
                                    first_start_time.day,
                                    static_slot.start_time.hour,
                                    static_slot.start_time.min)
    first_start_time += 4.weeks if first_start_time < @current_time
    first_start_time
  end

  def determine_intervals_with_current_time(static_slot)
    gaps = {}
    type_of_current_week = determine_week_type(@current_time)
    gaps['week'] = ((StaticSlot.week_types[static_slot.week_type] + 1) - (StaticSlot.week_types[type_of_current_week] + 1 )) % 4
    gaps['day'] = ((StaticSlot.week_days[static_slot.week_day] + 1) - @current_time.strftime('%u').to_i) % 7
    gaps['week'] -= 1 if (StaticSlot.week_days[static_slot.week_day] + 1) < @current_time.strftime('%u').to_i
    (gaps['week'].weeks + gaps['day'].days)
  end

  def determine_week_type(current_hour)
    reference = DateTime.new(2020, 9, 7)
    week_in_seconds = 60 * 60 * 24 * 7
    week_count_between_reference_and_current_hour = (current_hour.at_beginning_of_week.to_i - reference.to_i) / week_in_seconds

    week_types = %w[D A B C] # we must have the index 0 for D and index 1 for A because (multiple of 4 modulo 4 == 0)
    week_types[week_count_between_reference_and_current_hour % 4]
  end

  def already_enrolled_for_this_time_slot?(member, mission_slot)
    Mission::Slot.find_by(start_time: mission_slot.start_time, member_id: member.id).present?
  end
end
