# frozen_string_literal: true

class ChangeMissionsColumnToBeNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :missions, :name, false
    change_column_null :missions, :description, false
  end
end
