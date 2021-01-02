# frozen_string_literal: true

# Manages Members Enrollments on Missions
class EnrollmentsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_mission, only: %i[create destroy]

  def create
    create_transaction = Enrollments::CreateTransaction.new.with_step_args(
      validate: [mission: @mission]
    ).call(permitted_params)

    return flash[:alert] = create_transaction.failure unless create_transaction.success?

    flash[:notice] = translate '.confirm_enroll'
    redirect_to mission_path(params[:mission_id])
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
      prepared_params
    end
  end

  def prepared_params
    returned_params = params.require(:enrollment).permit(:member_id, :mission_id, start_time: [])
    start_times = returned_params['start_time'].sort
    returned_params['end_time'] = start_times.last.to_datetime + 90.minutes
    returned_params['start_time'] = start_times.first.to_datetime
    returned_params
  end

  def set_mission
    @mission = Mission.find(params[:mission_id])
  end
end
