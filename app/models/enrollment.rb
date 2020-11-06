# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  end_time   :time
#  member_id  :bigint(8)        not null
#  mission_id :bigint(8)


# Represents a member enrolling to a given Mission
class Enrollment < ApplicationRecord

  belongs_to :mission
  def duration
    return 0 if start_time == nil || end_time == nil

    ((end_time - start_time) / 60 / 60).round 1
  end

end
