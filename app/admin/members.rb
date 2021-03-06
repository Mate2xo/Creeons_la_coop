# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
ActiveAdmin.register Member do
  includes :groups, :enrollments, :group_members
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
                group_members_attributes: [[%i[id assignment]]],
                member_static_slots_attributes: [:id, :static_slot_id, :member_id, :_destroy]

  menu if: proc { authorized? :index, %i[active_admin Member] } # display menu according to ActiveAdmin::Policy

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
    column(t('.worked_hours'), &:hours_worked_in_the_last_three_months)
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
    column(worked_hours_title_for_given_month(Date.current - 2.months)) do |member|
      member.monthly_worked_hours(Date.current - 2.months)
    end
    column(worked_hours_title_for_given_month(Date.current - 1.month)) do |member|
      member.monthly_worked_hours(Date.current - 1.month)
    end
    column(worked_hours_title_for_given_month(Date.current)) do |member|
      member.monthly_worked_hours(Date.current)
    end
    column :cash_register_proficiency
    column :register_id
  end

  show do
    attributes_table_for resource do
      default_attribute_table_rows.each do |field|
        row field
      end
      table_for member.group_members do
        column t('.groups') do |group_member|
          link_to Arbre::Context.new { (status_tag class: 'important', label: group_member.group.name) },
                  [:admin, group_member.group]
        end
        column t('.assignment'), :assignment
      end
      table_for member.static_slots do
        column(StaticSlot.model_name.human, &:full_display)
      end
      table_for member.history_of_static_slot_selections, t('.selections_history') do
        column StaticSlot.model_name.human do |record|
          record.static_slot.decorate.full_display
        end
        column(t('.selected_at'), &:created_at)
      end
    end
  end

  form decorate: true do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone_number
      f.input :role
      f.input :moderator
      f.input :cash_register_proficiency
      f.input :register_id
      f.input :biography

      tabs do
        resource.group_members.each do |group_member|
          tab group_member.group.name do
            f.fields_for :group_members, group_member do |group_member_form|
              group_member_form.text_area :assignment
            end
          end
        end
      end

      f.input :groups, as: :check_boxes
      f.has_many :member_static_slots, allow_destroy: true, new_record: true do |member_static_slot_form|
        member_static_slot_form.input :static_slot_id, as: :select, collection: selectable_static_slots
      end
    end
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

  action_item :remove_static_slots_of_a_member, only: %i[show edit] do
    link_to t('.remove_static_slots_of_this_member'),
            remove_static_slots_of_a_member_admin_members_path(member_id: resource.id),
            method: :put
  end

  collection_action :enroll_static_members, method: :post do
    # We must wait the end of page reload from the redirection.
    # Otherwise if the job finishes before the page reload,
    # the user won't get the 'job finished' notification from ActionCable
    EnrollStaticMembersJob.set(wait: 5.seconds).perform_later

    redirect_to admin_members_path, notice: t('.enroll_in_progress')
  end

  collection_action :remove_static_slots_of_a_member, method: :put do
    member = Member.find(params[:member_id])
    member.member_static_slots.destroy_all
    redirect_to admin_member_path(member), notice: t('member_static_slots.destroy.reset_success')
  end

  controller do
    def create(options = {}, &block) # rubocop:disable Metrics/MethodLength
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
