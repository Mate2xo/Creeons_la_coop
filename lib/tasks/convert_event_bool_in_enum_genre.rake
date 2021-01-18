# frozen_string_literal: true

# This namespace contains all tasks that adapt existing data when the DB structure changes
namespace :conversion do # rubocop:disable Metrics/BlockLength
  desc 'it sets the :genre enum to the value of 2 (= event) for missions that have the :event boolean attribute set to true'
  task mission_event_bool_to_genre_enum: :environment do
    puts ''.ljust 80, '*'
    puts 'start migration'.center 80
    puts ''.ljust 80, '*'
    file = File.open(Rails.root.join('db/convert_event_bool_in_genre_enum/convert_event_bool_in_genre_enum.sql'))
    ActiveRecord::Base.connection.execute(file.read)
    file.close
    puts ''.ljust 80, '*'
    puts 'migration done'.center 80
    puts ''.ljust 80, '*'

    puts ''.ljust 80, '*'
    if check_data_consistency_for_event_bool_convertion
      puts 'migration success'.center 80
    else
      puts 'migration failure'.center 80
    end
    puts ''.ljust 80, '*'
  end
end

def check_data_consistency_for_event_bool_convertion
  puts ''.ljust 80, '*'
  puts 'checking of data consistency'.center 80
  puts ''.ljust 80, '*'
  check = true
  Mission.where(event: true).each do |mission|
    check = false if mission.genre != 'event'
  end
  check
end
