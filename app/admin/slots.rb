# frozen_string_literal: true

ActiveAdmin.register Mission::Slot, as: 'slots' do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :member_id
  belongs_to :mission

  index do
    column :member
    column :mission
    actions
  end

  form as: 'slot' do |f|
    f.inputs :member
    actions
  end

  controller do
    def update
      resource.update(member_id: params[:slot][:member_id])
      redirect_to admin_mission_path(params[:mission_id])
    end
  end
  
end
