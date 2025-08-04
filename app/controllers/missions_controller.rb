# frozen_string_literal: true

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods other than attributes: #addresses, #members
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

  ##
  # Updates an existing mission with permitted parameters.
  #
  # On success, redirects to the mission's detail page with a success notice. On failure, renders the edit form with an error message.
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

  ##
  # Handles the creation of a mission, supporting both recurrent and single missions.
  # For recurrent missions, validates and generates multiple records; for single missions, attempts to save and renders the result.
  # Redirects or renders views with appropriate flash messages based on the outcome.
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
      flash[:error] << " #{mission.errors.full_messages.join(', ')}"
      redirect_to new_mission_path
    end
  end

  ##
  # Executes the mission update transaction with appropriate step arguments based on the mission's regulation status.
  # @return [Missions::UpdateTransaction::Result] The result of the update transaction.
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

  ##
  # Returns the permitted parameters for regulated missions, allowing nested enrollment attributes with time slots.
  # @return [ActionController::Parameters] The merged parameters for regulated mission creation or update.
  def regulated_mission_params
    enrollment_params = params.require(:mission)
                              .permit(enrollments_attributes: [
                                        :id, :_destroy, :member_id,
                                        {time_slots: []}
                                      ])
    base_params.merge(enrollment_params)
  end

  ##
  # Returns permitted parameters for standard missions, including nested enrollment attributes with start and end times.
  # @return [ActionController::Parameters] The merged permitted parameters for a standard mission.
  def standard_mission_params
    enrollment_params = params.require(:mission)
                              .permit(enrollments_attributes: %i[id _destroy member_id start_time end_time])
    base_params.merge(enrollment_params)
  end

  ##
  # Loads the specified mission with its enrollments and members, and authorizes access for the current user.
  # Sets the loaded mission to the @mission instance variable.
  def set_authorized_mission
    @mission = authorize Mission.includes(enrollments: :member).find(params[:id])
  end

  ##
  # Parses and returns a hash of start and end dates for filtering missions.
  # Returns nil if either date is missing or invalid.
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
