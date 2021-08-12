# frozen_string_literal: true

module AssignMembersHelpers
  def assign_members_to_this_mission(members_count,
                                     mission,
                                     start_time = mission.start_date,
                                     end_time = mission.due_date)

    members_count.times do # rubocop:disable FactoryBot/CreateList
      create :enrollment,
             start_time: start_time,
             end_time: end_time,
             mission_id: mission.id,
             member_id: (create :member).id
    end
  end
end
