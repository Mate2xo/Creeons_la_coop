# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  member_id  :bigint(8)        not null
#  mission_id :bigint(8)        not null
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  end_time   :time
#

class Enrollment < ApplicationRecord
  belongs_to :member
  belongs_to :mission

  before_save :set_defaults

  private

  def set_defaults
    self.start_time ||= mission.start_date.to_time
    self.end_time ||= mission.due_date.to_time
  end
end
