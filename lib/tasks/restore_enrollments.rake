# frozen_string_literal: true

# This task is only a one-time use
desc 'restore_enrollments_from_2020_10_01_to_2020_01_04_from_csv'
task restore_enrollments_from_csv: :environment do
  file = File.open(Rails.root.join('db/restore_enrollments/enrollments_restoration_from_csv_file.sql'))
  ActiveRecord::Base.connection.execute(file.read)
  file.close
  puts 'restoration_done'
end
