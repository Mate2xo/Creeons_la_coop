# frozen_string_literal: true

# JSON formatted for use in the FullCalendar plugin (JS)
json.array! @missions do |mission|
  json.id mission.id
  json.title mission.name
  json.start mission.start_date
  json.end mission.due_date
  json.url mission_path(mission.id)
  json.extendedProps delivery_expected: mission.delivery_expected,
                     members: mission.members

  # events colors
  members = mission.members
  if members.length == mission.max_member_count
    json.color 'grey'
  elsif mission.event then json.color 'orange'
  elsif mission.min_member_count != 0 && members.empty?
    json.color 'red'
  elsif members.length < mission.min_member_count || members.all?(&:untrained?)
    json.color 'purple'
  elsif members.length >= mission.min_member_count
    json.color 'green'
  end
end
