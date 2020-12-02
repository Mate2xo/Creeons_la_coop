# frozen_string_literal: true

# Manages Members participations on Events
class ParticipationsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_event, only: %i[destroy]

  def create
    @participation = Participation.create(participation_params)
    user_feedback_on_creation

    redirect_to mission_path(params[:mission_id])
  end

  def destroy
    @event.participants.destroy(current_member.id)
    flash[:alert] = translate '.remove_participation'
    redirect_to mission_path(params[:mission_id])
  end

  private

  def permitted_params
    params.require(:participation).permit(:participant_id)
  end

  def participation_params
    participation_params = permitted_params
    participation_params.merge!(participant_id: current_member.id) if permitted_params[:participant_id].blank?
    participation_params.merge(event_id: params[:mission_id])
  end

  def user_feedback_on_creation
    if @participation.persisted?
      flash[:notice] = translate '.confirm_participation'
    else
      flash[:alert] = translate '.participation_error',
                                errors: @participation.errors.full_messages.join(', ')
    end
  end

  def set_event
    @event = Mission.find(params[:mission_id])
  end
end
