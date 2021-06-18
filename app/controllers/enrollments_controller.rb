# frozen_string_literal: true

# Manages Members Enrollments on Missions
class EnrollmentsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_mission, only: %i[create destroy]

  def create
    create_transaction = Enrollments::CreateTransaction.new.with_step_args(
      include_mission_date_in_enrollment_datetimes: [mission: @mission],  #todo change include mission in inputs
      validate: [mission: @mission],
      transform_time_slots_in_time_params_for_enrollment: [regulated: @mission.regulated?,
                                                           time_slots: permitted_params['time_slots']]
    ).call(permitted_params)

    if create_transaction.success?
      flash[:notice] = translate '.confirm_enroll'
      redirect_to mission_path(params[:mission_id])
    else
      flash[:alert] = create_transaction.failure
      render 'missions/index'
    end
  end

  def destroy
    @mission.members.destroy(current_member.id)
    flash[:alert] = translate '.disenroll'
    redirect_to mission_path(params[:mission_id])
  end

  private

  def permitted_params
    if @mission.genre != 'regulated'
      params.require(:enrollment).permit(:member_id, :mission_id, :start_time, :end_time)
    else
      params.require(:enrollment).permit(:member_id, :mission_id, time_slots: [])
    end
  end

  def set_mission
    @mission = Mission.find(params[:mission_id])
  end
end
