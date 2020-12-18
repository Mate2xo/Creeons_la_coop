# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
ActiveAdmin.register Member do
  includes :groups
  permit_params :email,
                :password,
                :encrypted_password,
                :first_name,
                :last_name,
                :biography,
                :phone_number,
                :role,
                :moderator,
                :confirmed_at,
                :password_confirmation,
                :cash_register_proficiency,
                :register_id,
                group_ids: [],
                static_slot_ids: []

  decorate_with MemberDecorator

  index do
    selectable_column
    column :first_name
    column :last_name
    column :role
    column(:group) do |member|
      group_links = member.groups.map { |group| auto_link group }
      safe_join group_links, ', '
    end
    column(t('.worked_hours')) { |member| member.hours_worked_in_the_last_three_months }
    column :cash_register_proficiency
    column :register_id
    column :email
    actions
  end

  csv do
    column :email
    column :first_name
    column :last_name
    column :phone_number
    column :role
    column(:group) { |member| member.groups.map(&:name).join(', ') }
    column(t('active_admin.resource.index.worked_hours')) { |member| member.hours_worked_in_the_last_three_months(csv: true) }
    column :cash_register_proficiency
    column :register_id
  end

  show do
    attributes_table_for resource do
      default_attribute_table_rows.each do |field|
        row field
      end
      table_for member.groups do
        column 'groups' do |group|
          link_to Arbre::Context.new { (status_tag class: 'important', label: group.name) }, [:admin, group]
        end
      end
      table_for member.static_slots do
        column StaticSlot.model_name.human do |static_slot|
          static_slot.full_display
        end
      end
      table_for member.history_of_static_slot_selections, t('.selections_history') do
        column StaticSlot.model_name.human do |record|
          record.static_slot.decorate.full_display
        end
        column(t('.selected_at')) { |record| record.created_at }
      end
    end
  end

  form decorate: true do |f|
    f.inputs :first_name,
             :last_name,
             :email,
             :phone_number,
             :role,
             :moderator,
             :cash_register_proficiency,
             :register_id,
             :biography
    f.input :groups, as: :check_boxes
    f.input :static_slots, as: :check_boxes, collection: StaticSlot.all.map { |static_slot| [static_slot.decorate.full_display, static_slot.id] }
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

  action_item :enroll_static_members, only: :index do
    link_to t('.enroll_static_members'),
            enroll_static_members_admin_members_path,
            data: { confirm: t('.confirm_enroll_static_members') }, method: :post
  end

  action_item :remove_static_slots_of_a_member, only: [:show, :edit] do
    link_to t('.remove_static_slots_of_this_member'),
            remove_static_slots_of_a_member_admin_members_path(member_id: resource.id),
            method: :put
  end

  collection_action :enroll_static_members, method: :post do
    EnrollStaticMembersJob.perform_later
    redirect_to admin_members_path, notice: t('.enroll_in_progress')
  end

  collection_action :remove_static_slots_of_a_member, method: :put do
    member = Member.find(params[:member_id])
    member.static_slot_members.destroy_all
    redirect_to admin_member_path(member), notice: 'success'
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

    def update
      resource.skip_reconfirmation!
      super
    end
  end
end
# rubocop: enable Metrics/BlockLength
