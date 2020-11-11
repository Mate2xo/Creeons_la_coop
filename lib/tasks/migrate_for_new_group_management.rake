# frozen_string_literal: true

desc 'migrate for new group management'
task migration_group_from_member_model_to_group_model: :environment do
  if ActiveRecord::Base.connection.table_exists?(:tempo_group_table)
    ActiveRecord::Base.connection.execute('DROP TABLE tempo_group_table')
  end
  Group.destroy_all
  puts '****************************************************************************************************'
  puts '*                               start migration                                                    *'
  puts '****************************************************************************************************'
  file = File.open('db/group_migration/group_migrate.sql')
  ActiveRecord::Base.connection.execute(file.read)
  file.close
  puts '****************************************************************************************************'
  puts '*                               migration done                                                     *'
  puts '****************************************************************************************************'
  check_data_consistency
  if ActiveRecord::Base.connection.table_exists?(:tempo_group_table)
    ActiveRecord::Base.connection.execute('DROP TABLE tempo_group_table')
  end
end

def check_data_consistency
  puts '****************************************************************************************************'
  puts '*                               start verification                                                 *'
  puts '****************************************************************************************************'
  valid = true
  Member.all.select{ |member| member.group.present? }.each do |member|
    group_name = ActiveRecord::Base.connection.execute("SELECT name FROM tempo_group_table where number='#{member.group}'")[0]['name']
    puts group_name
    puts member.groups[0]['name']

    valid = false if group_name != member.groups[0]['name']
  end

  puts 'all is ok' if valid
  puts '****************************************************************************************************'
  puts '*                               verification done                                                  *'
  puts '****************************************************************************************************'
end
