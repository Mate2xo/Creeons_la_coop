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
      row(:cash_register_proficiency_requirement) do |resource|
        Mission.human_enum_name('cash_register_proficiency_requirement', resource.cash_register_proficiency_requirement)
      end
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
