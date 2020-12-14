# frozen_string_literal: true

# A Slot is a one fraction of a Mission, that can be taken by a Member. One Slot lasts for 90 minutes.
# A Mission has a limited number of slots (n = duration_of_mission / 90minutes * members_count)
class SlotsController < ApplicationController
  decorates_assigned :mission

  before_action :authenticate_member!
  before_action :set_mission, only: %i[update]

  def update
    slot_manager = Slot::Assigner.new(@mission, permitted_params[:member_id], permitted_params[:start_times])
    if slot_manager.assign
      flash[:notice] = translate '.confirm_update'
      redirect_to mission_path(@mission)
    else
      flash[:alert] = (translate '.enroll_error') + slot_manager.errors.join(', ')
      render 'missions/show'
    end
  end

  private

  def permitted_params
    params.require(:slot).permit(:member_id, start_times: [])
  end

  def set_mission
    @mission = Mission.find(params[:mission_id])
  end
end
