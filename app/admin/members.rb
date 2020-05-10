# frozen_string_literal: true

ActiveAdmin.register Member do
  permit_params :email, :encrypted_password, :first_name, :last_name, :biography,
                :phone_number, :role, :moderator, :group, :confirmed_at,
                :password, :password_confirmation, :cash_register_proficiency

  index do
    selectable_column
    column :first_name
    column :last_name
    column :role
    column '3 heures faites?' do |member| member.worked_three_hours?(Date.current) end
    column :group do |member| Member.human_enum_name(:group, member.group) end
    column :cash_register_proficiency
    column :email
    actions
  end

  form do |f|
    f.inputs :first_name, :last_name, :email, :phone_number, :role,
             :moderator, :group, :cash_register_proficiency, :biography
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
    link_to t('active_admin.invite_member'), new_member_invitation_path
  end

  controller do
    def create(options = {}, &block)
      new_unloggable_member = build_resource
      first_name = new_unloggable_member.first_name
      last_name = new_unloggable_member.last_name
      new_unloggable_member.email = "#{first_name}.#{last_name}.#{Date.current}@compte.web.inactif"

      def new_unloggable_member.password_required?
        false
      end

      def new_unloggable_member.email_required?
        false
      end

      options[:location] ||= smart_resource_url if create_resource(new_unloggable_member)

      respond_with_dual_blocks(new_unloggable_member, options, &block)
    end
  end
end
