# frozen_string_literal: true

ActiveAdmin.register Member do
  permit_params :email, :encrypted_password, :first_name, :last_name, :biography, :phone_number, :role, :group, :confirmed_at, :password, :password_confirmation

  index do
    selectable_column
    column :first_name
    column :last_name
    column :role
    column :group do |member| t("main_app.model.member.group.#{member.group}") end
    column :email
    actions
  end

  form do |f|
    f.inputs :first_name, :last_name, :email, :role, :group, :phone_number, :biography
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :email
  filter :role
  filter :group

  action_item :invite_member, only: :index do
    link_to t("active_admin.invite_member"), new_member_invitation_path
  end
end
