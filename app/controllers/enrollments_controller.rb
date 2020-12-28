# frozen_string_literal: true

# Manages Members Enrollments on Missions
class EnrollmentsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_mission, only: %i[create destroy]

  def create
    return flash[:alert] = translate('.max_member_count_reached') if member_slots_full?

    @enrollment = Enrollment.create(enrollment_params)
    user_feedback_on_creation

    redirect_to mission_path(params[:mission_id])
  end

  def destroy
    @mission.members.destroy(current_member.id)
    flash[:alert] = translate '.disenroll'
    redirect_to mission_path(params[:mission_id])
  end

  private

  def permitted_params
    params.require(:enrollment).permit(:start_time, :end_time, :member_id)
  end

  def enrollment_params
    enrollment_params = permitted_params
    enrollment_params.merge!(member_id: current_member.id) if permitted_params[:member_id].blank?
    enrollment_params.merge(mission_id: params[:mission_id])
  end

  def user_feedback_on_creation
    if @enrollment.persisted?
      flash[:notice] = translate '.confirm_enroll'
    else
      flash[:alert] = translate '.enroll_error',
                                errors: @enrollment.errors.full_messages.join(', ')
    end
  end

  def set_mission
    @mission = Mission.find(params[:mission_id])
  end

  def member_slots_full?
    return false if @mission.max_member_count.nil?

    @mission.members.count >= @mission.max_member_count || @mission.members.where(id: current_member.id).present?
  end
end
