# frozen_string_literal: true

ActiveAdmin.register Member do
  permit_params :email, :encrypted_password, :first_name, :last_name, :biography, :phone_number, :role, :confirmed_at, :password, :password_confirmation

  index do
    selectable_column
    column :first_name
    column :last_name
    column :role
    column :email
    actions
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :phone_number
      f.input :biography
    end
    actions
  end
end
