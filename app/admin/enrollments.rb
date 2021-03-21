# frozen_string_literal: true

ActiveAdmin.register Enrollment do # rubocop:disable Metrics/BlockLength
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :member_id, :start_time, :end_time
  belongs_to :mission

  index do
    column :member
    column :mission
    column(:start_time) { |enrollment| enrollment.start_time.strftime('%H:%M') }
    column(:end_time) { |enrollment| enrollment.end_time.strftime('%H:%M') }
    actions
  end

  form do |f|
    unless f.object.persisted?
      f.object.start_time = resource.mission.start_date
      f.object.end_time = resource.mission.due_date
    end
    f.inputs do
      f.input :member, include_blank: false
      f.input :start_time, include_blank: false
      f.input :end_time, include_blank: false
      actions
    end
  end

  controller do # rubocop:disable Metrics/BlockLength
    def create # rubocop:disable Metrics/AbcSize
      build_resource
      if create_enrollment_transaction.success?
        flash[:notice] = translate 'enrollments.create.confirm_enroll'
        redirect_to admin_mission_path(params[:mission_id])
      else
        flash[:error] = create_enrollment_transaction.failure
        render :new
      end
    end

    def update # rubocop:disable Metrics/AbcSize
      build_resource
      if update_enrollment_transaction.success?
        flash[:notice] = translate 'enrollments.update.confirm_update'
        redirect_to admin_mission_path(params[:mission_id])
      else
        flash[:error] = update_enrollment_transaction.failure
        render :edit
      end
    end

    private

    def create_enrollment_transaction # rubocop:disable Metrics/MethodLength
      @create_enrollment_transaction ||=
        begin
          mission = Mission.find(params[:mission_id])
          member = Member.find(permitted_params[:enrollment][:member_id])
          input = permitted_params[:enrollment].merge({ mission: mission, member: member })
          Admin::Enrollments::CreateTransaction
            .new
            .call(input)
        end
    end

    def update_enrollment_transaction # rubocop:disable Metrics/MethodLength
      @update_enrollment_transaction ||=
        begin
          mission = Mission.find(params[:mission_id])
          member = Member.find(permitted_params[:enrollment][:member_id])
          input = permitted_params[:enrollment].merge({ mission: mission, member: member, id: params[:id] })
          Admin::Enrollments::UpdateTransaction
            .new
            .call(input)
        end
    end
  end
end
