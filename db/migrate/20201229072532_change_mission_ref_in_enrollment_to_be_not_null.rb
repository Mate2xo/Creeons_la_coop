class ChangeMissionRefInEnrollmentToBeNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :enrollments, :mission_id, false
  end
end
