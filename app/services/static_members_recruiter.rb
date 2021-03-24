# frozen_string_literal: true

# Fetches all existing StaticSlots, and enrolls the associated Member to the associated Mission
# on a given StaticSlot start_time
class StaticMembersRecruiter # rubocop:disable Metrics/ClassLength
  attr_reader :reports
  def initialize
    @reports = []
    @static_slots = StaticSlot.all
    @members_with_static_slots = Member.all.select { |member| member.static_slots.any? }
    @current_time = DateTime.current
  end

  def call
    enrollments_for_all_members
  end

  def enrollment_for_one_member(member)
    member.static_slots.each do |static_slot|
      enrollments_for_one_static_slot(member, static_slot)
    end
    merge_multi_enrolls_on_one_mission(member)
  end

  def week_type_of_this_datetime(current_hour)
    reference = DateTime.new(2020, 9, 7)
    week_in_seconds = 60 * 60 * 24 * 7
    week_count_between_reference_and_current_hour = (current_hour.at_beginning_of_week.to_i - reference.to_i) /
                                                    week_in_seconds

    week_types = %w[D A B C] # we must have the index 0 for D and index 1 for A because (multiple of 4 modulo 4 == 0)
    week_types[week_count_between_reference_and_current_hour % 4]
  end

  private

  def enrollments_for_all_members
    @members_with_static_slots.each do |member|
      enrollment_for_one_member(member)
    end
  end

  def merge_multi_enrolls_on_one_mission(member)
    member.missions.each do |mission|
      enrollments = Enrollment.where(member_id: member.id, mission_id: mission.id)
      merge_enrolls(enrollments) if enrollments.count > 1
    end
  end

  def merge_enrolls(enrollments)
    enrollments = enrollments.order(:start_time)
    enrollment_created = Enrollment.create(start_time: enrollments.first.start_time,
                                           end_time: enrollments.last.end_time,
                                           mission_id: enrollments.first.mission_id,
                                           member_id: enrollments.first.member_id)
    enrollments.where('id != ?', enrollment_created.id).destroy_all if enrollment_created
  end

  def enrollments_for_one_static_slot(member, static_slot)
    time_slot = first_time_slot_corresponding_to_static_slot_after_current_date(static_slot)
    enroll_on_time_slot(time_slot, member)
  end

  def enroll_on_time_slot(time_slot, member)
    return if member.enrollments.any? { |enrollment| enrollment.contain_this_time_slot?(time_slot) }

    missions = search_missions_with_this_time_slot(member, time_slot)
    return if missions.nil?

    mission = find_adequate_mission_or_send_error_report(member, missions, time_slot)
    return if mission.nil?

    Enrollment.create(mission: mission, member: member, start_time: time_slot, end_time: time_slot + 90.minutes)
  end

  def search_missions_with_this_time_slot(member, time_slot)
    missions = Mission.where(genre: 'regulated')
    selected_missions = missions.select do |mission|
      mission.max_member_count > mission.members.count && mission.selectable_time_slots.include?(time_slot)
    end

    return selected_missions if selected_missions.present?

    @reports << I18n.t('static_members_recruiter.reports.mission_unavailability',
                       first_name: member.first_name,
                       last_name: member.last_name,
                       time_slot: time_slot.strftime('%D %Hh%M'))
    nil
  end

  def first_time_slot_corresponding_to_static_slot_after_current_date(static_slot)
    first_start_time = @current_time + intervals_with_current_time(static_slot)
    first_start_time = DateTime.new(first_start_time.year,
                                    first_start_time.month,
                                    first_start_time.day,
                                    static_slot.start_time.hour,
                                    static_slot.start_time.min)
    first_start_time += 4.weeks if first_start_time < @current_time
    first_start_time
  end

  def intervals_with_current_time(static_slot)
    days_count = interval_in_day_between_current_time_and_next_day_of_same_type(static_slot)
    weeks_count = interval_in_week_between_an_datetime_and_next_week_of_same_type(static_slot,
                                                                                  @current_time + days_count)
    (weeks_count.weeks + days_count.days)
  end

  def interval_in_week_between_an_datetime_and_next_week_of_same_type(static_slot, datetime)
    type_of_current_week = week_type_of_this_datetime(datetime)
    rank_of_static_slot_week = (StaticSlot.week_types[static_slot.week_type] + 1)
    rank_of_current_week = (StaticSlot.week_types[type_of_current_week] + 1)
    (rank_of_static_slot_week - rank_of_current_week) % 4
  end

  def interval_in_day_between_current_time_and_next_day_of_same_type(static_slot)
    rank_of_static_slot_day = StaticSlot.week_days[static_slot.week_day] + 1
    rank_of_current_day = @current_time.strftime('%u').to_i
    (rank_of_static_slot_day - rank_of_current_day) % 7
  end

  def find_adequate_mission_or_send_error_report(member, missions, time_slot)
    finded_mission = missions.find { |mission| adequate_cash_register_requirement?(member, mission) }

    return finded_mission if finded_mission.present?

    @reports << I18n.t('static_members_recruiter.reports.mission_unavailability',
                       first_name: member.first_name,
                       last_name: member.last_name,
                       time_slot: time_slot.strftime('%D %Hh%M'))
    nil
  end

  def adequate_cash_register_requirement?(member, mission)
    cash_register_proficiency_level_of_member =
      Member.cash_register_proficiencies[member.cash_register_proficiency]

    cash_register_proficiency_level_of_mission =
      Mission.cash_register_proficiency_requirements[mission.cash_register_proficiency_requirement]

    mission.max_member_count - mission.members.count >= 2 ||
      cash_register_proficiency_level_of_member >= cash_register_proficiency_level_of_mission
  end
end
