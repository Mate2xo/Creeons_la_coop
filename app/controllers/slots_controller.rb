# frozen_string_literal: true

# A slot is a place of a mission who can be take by a member. The slots go on 90 minutes.
# A mission have a limited number of slots( n = duration_of_mission / 90 minutes * members_count).
class SlotsController < ApplicationController
  def update
    slot_manager = Slot::Manager.new(params[:mission_id], permitted_params[:member_id], permitted_params[:start_times])
    if slot_manager.manage
      flash[:notice] = translate '.confirm_update'
    else
      flash[:alert] = (translate '.enroll_error') + slot_manager.errors.join(', ')
    end
    @mission = Mission.find(params[:mission_id]).decorate
    render "missions/show"
  end

  private

  def permitted_params
    params.require(:slot).permit(:member_id, start_times: [])
  end
end
