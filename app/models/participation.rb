# frozen_string_literal: true

# == Schema Information
#
# Table name: participations
#
#  id               :bigint(8)        not null, primary key
#  participant_id   :bigint(8)        not null
#  mission_id       :bigint(8)        not null

# Represents a Member who take part in an event
class Participation < ApplicationRecord
  belongs_to :participant, class_name: 'Member'
  belongs_to :event, class_name: 'Mission', inverse_of: :participations, foreign_key: :event_id
end
