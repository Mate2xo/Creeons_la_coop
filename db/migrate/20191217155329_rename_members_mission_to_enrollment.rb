# frozen_string_literal: true

class RenameMembersMissionToEnrollment < ActiveRecord::Migration[5.2]
  def change
    rename_table "members_missions", "enrollments"
  end
end
