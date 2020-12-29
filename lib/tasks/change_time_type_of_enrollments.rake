# frozen_string_literal: true

desc 'change time type of enrollments attributes'
task change_time_type_of_enrollments: :environment do
  puts '****************************************************************************************************'
  puts '*                               start migration                                                    *'
  puts '****************************************************************************************************'
  file = File.open('db/change_time_type_of_enrollments/change_time_type_of_enrollments.sql')
  ActiveRecord::Base.connection.execute(file.read)
  file.close
  puts '****************************************************************************************************'
  puts '*                               migration done                                                     *'
  puts '****************************************************************************************************'
  if check_data_consistency_for_change_type
    puts '****************************************************************************************************'
    puts '*                               migration success                                                  *'
    puts '****************************************************************************************************'
  else
    puts '****************************************************************************************************'
    puts '*                               migration fail                                                     *'
    puts '****************************************************************************************************'
  end
end

def check_data_consistency_for_change_type
  puts '****************************************************************************************************'
  puts '*                               start verification                                                 *'
  puts '****************************************************************************************************'

  Enrollment.where('old_start_time IS NOT NULL or old_end_time IS NOT NULL').each do |enrollment|
    return false if enrollment.old_start_time != enrollment.start_time
    return false if enrollment.old_end_time != enrollment.end_time
  end
  true
end
