# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
ActiveAdmin.register Mission do
  permit_params :author_id,
                :name,
                :description,
                :event,
                :delivery_expected,
                :max_member_count,
                :min_member_count,
                :start_date,
                :due_date,
                :cash_register_proficiency_requirement

  index do
    selectable_column
    column :name
    column :description
    column :delivery_expected
    column :event
    column :due_date
    column :author
    column :cash_register_proficiency_requirement
    actions
  end

  form do |f|
    f.inputs do
      f.input :author,
              collection: options_from_collection_for_select(Member.all, :id, :email)
      f.input :name
      f.input :description
      f.input :delivery_expected
      f.input :event
      f.input :max_member_count
      f.input :min_member_count
      f.input :start_date
      f.input :due_date
      f.input :cash_register_proficiency_requirement,
              :as => :select,
              collection => Mission.cash_register_proficiency_requirements
    end

    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :start_date
      row :due_date
      row :min_member_count
      row :max_member_count
      row :delivery_expected
      row :event
      row :cash_register_proficiency_requirement
    end

    if resource.event
      panel 'Participants' do
        table_for resource.participations do
          column :participant
          column(:start_time) { mission.start_date.strftime('%H:%M') }
          column(:end_time) { mission.due_date.strftime('%H:%M') }
          column 'actions' do |participation|
            link_to(t('active_admin.delete'), admin_mission_participation_path(mission, participation), method: :delete)
          end
        end
      end
    else
      panel 'Slots' do
        table_for resource.slots.order(:start_time, :member_id) do
          column(:member)
          column(:start_time) { |slot| slot.start_time.strftime('%H:%M') }
          column(:end_time) { |slot| (slot.start_time + 90.minutes).strftime('%H:%M') }
          column 'actions' do |slot|
            link_to(t('active_admin.edit'), edit_admin_mission_slot_path(mission, slot)) +
              ' ' +
              link_to(t('active_admin.delete'), admin_mission_slot_path(mission, slot), method: :delete)
          end
        end
      end
    end
  end

  action_item :create_enrollment, only: :show do
    if resource.event
      link_to t('active_admin.new_model', model: Participation.model_name.human),
              new_admin_mission_participation_path(resource)
    end
  end

  action_item :generate_schedule, only: :index do
    link_to t('.generate_schedule'),
            generate_schedule_admin_missions_path,
            data: { confirm: t('.confirm_generation_schedule') }, method: :post
  end

  collection_action :generate_schedule, method: :post do
    GenerateScheduleJob.perform_later current_member
    redirect_to admin_missions_path, notice: t('.schedule_generation_in_progress')
  end
end
# rubocop: enable Metrics/BlockLength
