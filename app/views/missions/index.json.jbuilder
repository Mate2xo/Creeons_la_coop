# frozen_string_literal: true

# JSON formatted for use in the FullCalendar plugin (JS)
json.array! @missions do |mission|
  json.id mission.id
  json.title mission.name
  json.start mission.start_date
  json.end mission.due_date
  mission.regular ? json.color('green') : json.color('red')
  json.url mission_path(mission.id)
end
