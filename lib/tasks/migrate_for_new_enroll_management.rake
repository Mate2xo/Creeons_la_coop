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
  valid = check_event_data_consistency
  check_mission_data_consistency if valid
  puts '****************************************************************************************************'
  puts '*                               verification done                                                  *'
  puts '****************************************************************************************************'
end

def check_event_data_consistency

  valid = true
  event_enrollments = Enrollment.joins(:mission).where(missions: { event: true })
  valid = false if event_enrollments.count != Participation.all.count
  event_enrollments.each do |event_enrollment|
    result = Participation.find_by(participant_id: event_enrollment.member_id, event_id: event_enrollment.mission_id)
    valid false if result.nil?
  end

  if valid
    puts '****************************************************************************************************'
    puts '*                             event migration ok                                                   *'
    puts '****************************************************************************************************'
  else
    puts '****************************************************************************************************'
    puts '*                             event migration failed                                               *'
    puts '****************************************************************************************************'
  end
  valid
end

def check_mission_data_consistency
  valid = true
  missions = Mission.where(event: false)
  missions.each do |mission|
    members_ids_by_enrollments = Enrollment.where(mission_id: mission.id).select(:member_id).group(:member_id).count.keys.sort
    members_ids_by_slots = Mission::Slot.where(mission_id: mission.id).select(:member_id).group(:member_id).count.keys.reject(&:nil?).sort
    valid = false if members_ids_by_enrollments != members_ids_by_slots
  end

  if valid
    puts '****************************************************************************************************'
    puts '*                             mission migration ok                                                 *'
    puts '****************************************************************************************************'
  else
    puts '****************************************************************************************************'
    puts '*                             mission migration failed                                             *'
    puts '****************************************************************************************************'
  end
  valid
end
