# frozen_string_literal: true

ActiveAdmin.register Enrollment do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :member_id, :start_time, :end_time
  belongs_to :mission

  index do
    column :member
    column :mission
    column(:start_time) do |enrollment| enrollment.start_time.strftime('%H:%M') end
    column(:end_time) do |enrollment| enrollment.end_time.strftime('%H:%M') end
    actions
  end

  form do |f|
    f.inputs :member, :start_time, :end_time
    actions
  end
end
