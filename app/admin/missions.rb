# frozen_string_literal: true

ActiveAdmin.register Mission do
  permit_params :author_id, :name, :description, :due_date
end
