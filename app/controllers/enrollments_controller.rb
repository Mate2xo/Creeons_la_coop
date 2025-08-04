# frozen_string_literal: true

# Manages Members Enrollments on Missions
class EnrollmentsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_mission, only: %i[create destroy]

  ##
  # Enrolls the current member in a mission using permitted parameters.
  # Sets a flash notice on success or an alert with the failure message on error, then redirects to the mission's show page.
  def create
    create_transaction = Enrollments::CreateTransaction.new.with_step_args(
      include_mission_date_in_enrollment_datetimes: [mission: @mission],  #todo change include mission in inputs
      transform_time_slots_in_time_params_for_enrollment: [regulated: @mission.regulated?,
                                                           time_slots: permitted_params['time_slots']]
    ).call(permitted_params)

    if create_transaction.success?
      flash[:notice] = translate '.confirm_enroll'
    else
      flash[:alert] = create_transaction.failure
    end
    redirect_to mission_path(params[:mission_id])
  end

  ##
  # Removes the current member from the mission's enrollment and redirects to the mission page with a disenrollment alert.
  def destroy
    @mission.members.destroy(current_member.id)
    flash[:alert] = translate '.disenroll'
    redirect_to mission_path(params[:mission_id])
  end

  private

  ##
  # Returns the permitted enrollment parameters based on the mission's genre.
  # For regulated missions, permits time slots; otherwise, permits start and end times.
  # @return [ActionController::Parameters] The filtered parameters for enrollment.
  def permitted_params
    if @mission.genre == 'regulated'
      params.require(:enrollment).permit(:member_id, :mission_id, time_slots: [])
    else
      params.require(:enrollment).permit(:member_id, :mission_id, :start_time, :end_time)
    end
  end

  def set_mission
    @mission = Mission.find(params[:mission_id])
  end
end
