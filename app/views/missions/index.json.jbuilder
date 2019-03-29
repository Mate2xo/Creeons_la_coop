# frozen_string_literal: true

# JSON formatted for use in the FullCalendar plugin (JS)
json.array! @missions do |mission|
  json.title mission.name
  json.start mission.due_date
  json.regular mission.regular
end
