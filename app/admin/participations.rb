# frozen_string_literal: true

ActiveAdmin.register Participation do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :participant_id
  belongs_to :mission

  index do
    column :participant
    column :event
    actions
  end

  form do |f|
    f.inputs :participant
    actions
  end
end
