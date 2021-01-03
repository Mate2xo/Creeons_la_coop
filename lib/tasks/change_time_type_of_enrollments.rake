# frozen_string_literal: true

desc 'change time type of enrollments attributes'
task change_time_type_of_enrollments: :environment do
  puts ''.ljust 80, '*'
  puts 'start migration'.center 80
  puts ''.ljust 80, '*'
  file = File.open('db/change_time_type_of_enrollments/change_time_type_of_enrollments.sql')
  ActiveRecord::Base.connection.execute(file.read)
  file.close
  puts ''.ljust 80, '*'
  puts 'migration done'.center 80
  puts ''.ljust 80, '*'
  puts ''.ljust 80, '*'
  if check_data_consistency_for_change_type
    puts 'migration success'.center 80
  else
    puts 'migration fail'.center 80
  end
  puts ''.ljust 80, '*'
end

def check_data_consistency_for_change_type
  puts ''.ljust 80, '*'
  puts 'start verification'.center 80
  puts ''.ljust 80, '*'

  Enrollment.where('old_start_time IS NOT NULL or old_end_time IS NOT NULL').each do |enrollment|
    return false if enrollment.old_start_time != enrollment.start_time
    return false if enrollment.old_end_time != enrollment.end_time
  end
  true
end
