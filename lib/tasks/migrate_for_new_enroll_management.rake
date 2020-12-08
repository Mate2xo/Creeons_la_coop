# frozen_string_literal: true

desc 'migrate for new enroll management'
task migrate_for_new_enroll_management: :environment do
  puts '****************************************************************************************************'
  puts '*                               start migration                                                    *'
  puts '****************************************************************************************************'

  file = File.open('db/new_enrollment_management_migration/new_enroll_migrate.sql')
  ActiveRecord::Base.connection.execute(file.read)
  file.close

  puts '****************************************************************************************************'
  puts '*                               migration done                                                     *'
  puts '****************************************************************************************************'
  check_enroll_data_consistency
end

def check_enroll_data_consistency
  puts '****************************************************************************************************'
  puts '*                               start verification                                                 *'
  puts '****************************************************************************************************'

  check_event_data_consistency && check_mission_data_consistency

  puts '****************************************************************************************************'
  puts '*                               verification done                                                  *'
  puts '****************************************************************************************************'
end

def check_event_data_consistency
  event_enrollments = Enrollment.joins(:mission).where(missions: { event: true })
  return fail_message('event') if event_enrollments.count != Participation.all.count

  event_enrollments.each do |event_enrollment|
    result = Participation.find_by(participant_id: event_enrollment.member_id, event_id: event_enrollment.mission_id)
    return fail_message('event') if result.nil?
  end

  success_message('event')
end

def check_mission_data_consistency # rubocop:disable Metrics/AbcSize
  invalid_records = []
  Mission.where(event: false).each do |mission|
    members_ids_by_enrollments = Enrollment.where(mission_id: mission.id).select(:member_id)
                                           .group(:member_id).count.keys.sort
    members_ids_by_slots = Mission::Slot.where(mission_id: mission.id).select(:member_id)
                                        .group(:member_id).count.keys.reject(&:nil?).sort
    next if members_ids_by_enrollments == members_ids_by_slots

    invalid_records << "members_ids by enrollments #{members_ids_by_enrollments} and members ids by slots
    #{members_ids_by_slots} and mission_id #{mission.id} valid: false"
  end
  if invalid_records.any?
    fail_message
    puts invalid_records
  end
  success_message
end

def fail_message(type = 'mission')
  puts '****************************************************************************************************'
  if type == 'event'
    puts '*                             event migration failed                                               *'
  else
    puts '*                             mission migration failed                                             *'
  end
  puts '****************************************************************************************************'
  false
end

def success_message(type = 'mission')
  puts '****************************************************************************************************'
  if type == 'event'
    puts '*                             event migration ok                                                   *'
  else
    puts '*                             mission migration ok                                                 *'
  end
  puts '****************************************************************************************************'
  true
end
