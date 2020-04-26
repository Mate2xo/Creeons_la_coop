# frozen_string_literal: true

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods other than attributes: #addresses, #members
class MissionsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_authorized_mission, only: %i[show edit update destroy]

  def index
    @missions = Mission.includes(:members)
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(permitted_params)
    @mission.author = current_member

    generate(@mission)
  end

  def show; end

  def edit; end

  def update
    if @mission.update(permitted_params)
      flash[:notice] = translate 'activerecord.notices.messages.update_success'
      render :show
    else
      flash[:error] = translate 'activerecord.errors.messages.update_fail'
      render :edit
    end
  end

  def destroy
    if @mission.destroy
      flash[:notice] = translate 'activerecord.notices.messages.record_destroyed',
                                 model: Mission.model_name.human
    else
      flash[:error] = translate 'activerecord.errors.messages.destroy_fail',
                                model: Mission.model_name.human
    end
    redirect_to missions_path
  end

  private

  def generate(mission)
    if mission.recurrent
      validation_msg = RecurrentMissions.validate mission
      return render :new, alert: validation_msg unless validation_msg == true

      RecurrentMissions.new.generate(mission)
      flash[:notice] = translate 'activerecord.notices.messages.records_created',
                                 model: Mission.model_name.human
      redirect_to missions_path

    elsif mission.save
      flash[:notice] = translate 'activerecord.notices.messages.record_created',
                                 model: Mission.model_name.human
      render :show
    else
      flash[:error] = translate 'activerecord.errors.messages.creation_fail',
                                model: Mission.model_name.human
      redirect_to new_mission_path
    end
  end

  def permitted_params
    params.require(:mission).permit(
      :name, :description, :event, :delivery_expected,
      :recurrent, :recurrence_rule, :recurrence_end_date,
      :max_member_count, :min_member_count,
      :due_date, :start_date,
      addresses_attributes: %i[id postal_code city street_name_1 street_name_2 _destroy],
      enrollments_attributes: %i[id _destroy member_id start_time end_time]
    )
  end

  def set_authorized_mission
    @mission = authorize Mission.find(params[:id])
  end
end
