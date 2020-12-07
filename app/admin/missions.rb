# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
ActiveAdmin.register Mission do
  permit_params :author_id, :name, :description, :event, :delivery_expected,
                :max_member_count, :min_member_count,
                :start_date, :due_date

  index do
    selectable_column
    column :name
    column :description
    column :delivery_expected
    column :event
    column :due_date
    column :author
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
    end

    if resource.event
      panel 'Participants' do
        table_for resource.participations do
          column :participant
          column(:start_time) do mission.start_date.strftime('%H:%M') end
          column(:end_time) do mission.due_date.strftime('%H:%M') end
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
end
# rubocop: enable Metrics/BlockLength
