# frozen_string_literal: true

# This namespace contain all tasks who adapt the data at changements of db structure
namespace :convertion do # rubocop:disable Metrics/BlockLength
  desc 'it set enum genre at event for mission who have the event boolean at true'
  task convert_event_bool_in_enum_genre: :environment do
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
