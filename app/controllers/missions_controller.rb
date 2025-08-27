# frozen_string_literal: true

class MissionsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_authorized_mission, only: %i[show edit update destroy]

  def index
    respond_to do |format|
      format.html
      format.json do
        @missions = Mission.includes(:members, :enrollments)
        if (filter = date_filtering_params)
          @missions = @missions.where(start_date: filter[:from]..filter[:to])
        end
      end
    end
  end

  def show; end

  def new
    @mission = Mission.new
  end

  def edit; end

  def create
    @mission = Mission.new(permitted_params)
    @mission.author = current_member

    generate(@mission)
  end

  def update
    if update_transaction.success?
      flash[:notice] = translate 'activerecord.notices.messages.update_success'
      redirect_to mission_path(@mission)
    else
      flash[:error] = update_transaction.failure
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

  # Handles the creation of a mission, supporting both recurrent and single missions:
  # - for recurrent missions, validates and generates multiple records
  # - for single missions, attempts to save and renders the result.
  def generate(mission)
    if mission.recurrent
      validation_msg = RecurrentMissions.validate mission
      unless validation_msg == true
        flash[:alert] = validation_msg
        return render :new
      end

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
      flash[:error] << " #{mission.errors.full_messages.join(', ')}"
      redirect_to new_mission_path
    end
  end

  # @return [Dry::Monads::Result] The result of the update transaction.
  def update_transaction
    @_update_transaction ||=
      Missions::UpdateTransaction.new.with_step_args(
        transform_time_slots_in_time_params_for_enrollment: [regulated: @mission.regulated?],
        update: [mission: @mission]
      ).call(permitted_params)
  end

  def permitted_params
    if params['mission']['genre'] == 'regulated'
      regulated_mission_params
    else
      standard_mission_params
    end
  end

  def base_params
    params.require(:mission).permit(
      :name, :description, :event, :delivery_expected,
      :recurrent, :recurrence_rule, :recurrence_end_date,
      :max_member_count, :min_member_count,
      :cash_register_proficiency_requirement,
      :due_date, :start_date, :genre
    )
  end

  # @return [ActionController::Parameters]
  def regulated_mission_params
    enrollment_params = params.require(:mission)
                              .permit(enrollments_attributes: [
                                        :id, :_destroy, :member_id,
                                        {time_slots: []}
                                      ])
    base_params.merge(enrollment_params)
  end

  # @return [ActionController::Parameters]
  def standard_mission_params
    enrollment_params = params.require(:mission)
                              .permit(enrollments_attributes: %i[id _destroy member_id start_time end_time])
    base_params.merge(enrollment_params)
  end

  def set_authorized_mission
    @mission = authorize Mission.includes(enrollments: :member).find(params[:id])
  end

  # Parses and returns a hash of start and end dates from params to filter missions.
  # @return [Hash, nil] A hash with :from and :to keys containing Date objects, or nil if parsing fails.
  def date_filtering_params
    return unless params[:start].present? && params[:end].present?

    start_date = Date.parse(params[:start])
    end_date = Date.parse(params[:end])

    {from: start_date, to: end_date}
  rescue ArgumentError => _e
    nil
  end
end
