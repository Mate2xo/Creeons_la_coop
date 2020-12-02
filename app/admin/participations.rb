# frozen_string_literal: true

ActiveAdmin.register Participation do
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
