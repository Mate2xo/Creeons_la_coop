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

# A slot is a place of a mission who can be take by a member. The slots go on 90 minutes.
# A mission have a limited number of slots( n = duration_of_mission / 90 minutes * members_count).
class Mission::Slot < ApplicationRecord
  belongs_to :mission
  belongs_to :member, optional: true
end
