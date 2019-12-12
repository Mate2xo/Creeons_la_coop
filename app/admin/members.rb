# frozen_string_literal: true

ActiveAdmin.register Member do
  permit_params :email, :encrypted_password, :first_name, :last_name, :biography, :phone_number, :role, :moderator, :group, :confirmed_at, :password, :password_confirmation

  index do
    selectable_column
    column :first_name
    column :last_name
    column :role
    column :group do |member| Member.human_enum_name(:group, member.group) end
    column :cash_register_proficiency
    column :email
    actions
  end

  form do |f|
    f.inputs :first_name, :last_name, :email, :role, :moderator, :group, :cash_register_proficiency, :phone_number, :biography
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :email
  filter :role
  filter :group
  filter :cash_register_proficiency

  action_item :invite_member, only: :index do
    link_to t("active_admin.invite_member"), new_member_invitation_path
  end
end
