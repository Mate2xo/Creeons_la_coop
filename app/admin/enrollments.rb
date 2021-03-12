# frozen_string_literal: true

ActiveAdmin.register Enrollment do # rubocop:disable Metrics/BlockLength
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :member_id, :start_time, :end_time
  belongs_to :mission

  index do
    column :member
    column :mission
    column(:start_time) do |enrollment| enrollment.start_time.strftime('%H:%M') end
    column(:end_time) do |enrollment| enrollment.end_time.strftime('%H:%M') end
    actions
  end

  form do |f|
    f.inputs :member, :start_time, :end_time
    actions
  end

  controller do
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

    private

    def create_enrollment_transaction # rubocop:disable Metrics/MethodLength
      @create_enrollment_transaction ||=
        begin
          mission = Mission.find(params[:mission_id])
          input = permitted_params[:enrollment].merge({ mission: mission })
          Admin::Enrollments::CreateTransaction
            .new
            .call(input)
        end
    end
  end
end
