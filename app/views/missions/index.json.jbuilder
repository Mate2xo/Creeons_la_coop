# frozen_string_literal: true

# JSON formatted for use in the FullCalendar plugin (JS)
json.array! @missions do |mission|
  json.id mission.id
  json.title mission.name
  json.start mission.due_date
  json.regular mission.regular
  json.url mission_path(mission.id)
end
