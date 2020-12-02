# frozen_string_literal: true

# A Slot is a one fraction of a Mission, that can be taken by a Member. One Slot lasts for 90 minutes.
# A Mission has a limited number of slots (n = duration_of_mission / 90minutes * members_count)
class SlotsController < ApplicationController
  decorates_assigned :mission

  def update
    slot_manager = Slot::Assigner.new(params[:mission_id], permitted_params[:member_id], permitted_params[:start_times])
    if slot_manager.assign
      flash[:notice] = translate '.confirm_update'
    else
      flash[:alert] = (translate '.enroll_error') + slot_manager.errors.join(', ')
    end
    @mission = Mission.find(params[:mission_id])
    render 'missions/show'
  end

  private

  def permitted_params
    params.require(:slot).permit(:member_id, start_times: [])
  end
end
