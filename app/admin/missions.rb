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

    panel 'Participants' do
      table_for resource.enrollments do
        column :member
        column(:start_time) do |enrollment| enrollment.start_time.strftime('%H:%M') end
        column(:end_time) do |enrollment| enrollment.end_time.strftime('%H:%M') end
        column 'actions' do |enrollment|
          link_to(t('active_admin.edit'), edit_admin_mission_enrollment_path(mission, enrollment)) +
            ' ' +
            link_to(t('active_admin.delete'), admin_mission_enrollment_path(mission, enrollment), method: :delete)
        end
      end
    end
  end

  action_item :create_enrollment, only: :show do
    link_to t('active_admin.new_model', model: Enrollment.model_name.human),
            new_admin_mission_enrollment_path(resource)
  end
end
# rubocop: enable Metrics/BlockLength
