# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                :bigint(8)        not null, primary key
#  start_date        :datetime
#  mission_id        :bigint()
#  member_id         :bigint()
#

# A Slot is a one fraction of a Mission, that can be taken by a Member. One Slot lasts for 90 minutes.
# A Mission has a limited number of slots (n = duration_of_mission / 90minutes * members_count)
class Mission::Slot < ApplicationRecord
  belongs_to :mission
  belongs_to :member, optional: true
end
