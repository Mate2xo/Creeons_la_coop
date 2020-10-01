desc 'migrate for new group management'
task migration_sql: :environment do
  if ActiveRecord::Base.connection.table_exists?(:tempo_group_table)
    ActiveRecord::Base.connection.execute('DROP TABLE tempo_group_table')
  end

  Group.destroy_all
  file = File.open('insert_group_in_group_table.txt')
  ActiveRecord::Base.connection.execute(file.read)
  file.close

  file = File.open('create_tempo_table.txt')
  ActiveRecord::Base.connection.execute(file.read)
  file.close

  file = File.open('group_migrate.txt')
  ActiveRecord::Base.connection.execute(file.read)
  file.close

  verification
  ActiveRecord::Base.connection.execute('DROP TABLE tempo_group_table')
end

def verification
  valid = true
  Member.all.each do |member|
    group_name = ActiveRecord::Base.connection.execute("SELECT name FROM tempo_group_table where number='#{member.group}'")[0]['name']
    puts group_name
    puts member.groups[0]['name']

    valid = false if group_name != member.groups[0]['name']
  end

  puts 'all is ok' if valid
end
