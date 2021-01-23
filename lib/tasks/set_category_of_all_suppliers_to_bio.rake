# frozen_string_literal: true

# This namespace contains all tasks that adapt existing data when the DB structure changes
namespace :conversion do # rubocop:disable Metrics/BlockLength
  desc 'it sets the :category to the value of bio for productors that have the :local boolean attribute set to false'
  task set_category_of_all_suppliers: :environment do
    puts ''.ljust 80, '*'
    puts 'start migration'.center 80
    puts ''.ljust 80, '*'

    Productor.transaction do
      Productor.where(local: false, category: nil).each do |supplier|
        raise ActiveRecord::Rollback unless supplier.update(category: 'bio')

        puts "category of #{supplier.name} is setted"
      end
    end

    puts ''.ljust 80, '*'
    puts 'migration done'.center 80
    puts ''.ljust 80, '*'
  end
end
