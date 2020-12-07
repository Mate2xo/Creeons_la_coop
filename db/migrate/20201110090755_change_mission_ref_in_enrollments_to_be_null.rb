class ChangeMissionRefInEnrollmentsToBeNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :enrollments, :mission_id, true
  end
end
