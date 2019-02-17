# frozen_string_literal: true

ActiveAdmin.register Mission do
  permit_params :name, :description, "due_date(1i)", "due_date(2i)", "due_date(3i)", "due_date(4i)", "due_date(5i)"
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
