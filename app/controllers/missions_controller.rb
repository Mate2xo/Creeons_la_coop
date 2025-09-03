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
  ##
  # Generate records for a mission, handling both recurrent and single missions.
  #
  # For recurrent missions:
  # - Validates with RecurrentMissions.validate; if validation returns a non-true value,
  #   sets flash[:alert] to that message and renders :new.
  # - If valid, generates the recurring records via RecurrentMissions.new.generate,
  #   sets a creation notice and redirects to the missions index.
  #
  # For non-recurrent (single) missions:
  # - Attempts to save the given mission.
  # - On success: sets a creation notice and renders :show.
  # - On failure: sets flash[:error] to a creation failure message augmented with the
  #   mission's full error messages and redirects to new_mission_path.
  #
  # Side effects: may call render or redirect, and sets flash messages.
  # @param [Mission] mission The Mission instance to create (single) or expand (recurrent).
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

  ##
  # Build and return the strong-parameters hash for Mission from params.
  #
  # Chooses the permitted attribute set based on the incoming mission genre:
  # - If params['mission']['genre'] == 'regulated', permits base attributes plus regulated enrollment attributes.
  # - Otherwise, permits base attributes plus standard enrollment attributes.
  #
  # The method calls params.require(:mission).permit(...) and returns the resulting permitted Parameters object.
  # @return [ActionController::Parameters] The permitted mission parameters ready for assignment.
  def permitted_params
    if params['mission']['genre'] == 'regulated'
      params.require(:mission).permit(base_params + regulated_mission_params)
    else
      params.require(:mission).permit(base_params + standard_mission_params)
    end
  end

  ##
  # Returns the list of permitted top-level mission attributes used for strong parameters.
  # Includes scalar mission fields and the nested `addresses_attributes` allowed keys.
  # @return [Array<Symbol, Hash>] An array of permitted attribute names and a hash describing permitted nested address keys.
  def base_params
    [
      :cash_register_close_out_required,
      :delivery_expected,
      :description,
      :due_date,
      :event,
      :genre,
      :max_member_count,
      :min_member_count,
      :name,
      :recurrence_end_date,
      :recurrence_rule,
      :recurrent,
      :start_date,
      {addresses_attributes: %i[street_name_1 street_name_2 postal_code city _destroy id]}
    ]
  end

  ##
  # Permitted strong-parameter specification for regulated missions' nested enrollments.
  # Returns an array describing that `enrollments_attributes` may include `:id`, `:_destroy`,
  # `:member_id` and a nested `time_slots` array (used when building the overall params permit list).
  # @return [Array<Hash>] Array suitable for passing to `params.require(:mission).permit(...)`.
  def regulated_mission_params
    [
      enrollments_attributes: [:id, :_destroy, :member_id, {time_slots: []}]
    ]
  end

  ##
  # Returns the nested enrollment attributes allowed for standard (non-regulated) missions.
  # This is used by `permitted_params` when permitting `enrollments_attributes` that include
  # an enrollment `id`, `_destroy` flag, `member_id`, and `start_time`/`end_time`.
  # @return [Array<Hash>] An array suitable for `ActionController::Parameters#permit`, e.g.
  #   `[enrollments_attributes: %i[id _destroy member_id start_time end_time]]`.
  def standard_mission_params
    [
      enrollments_attributes: %i[id _destroy member_id start_time end_time]
    ]
  end

  ##
  # Loads the Mission identified by params[:id], eager-loads its enrollments and their members,
  # authorizes the record, and assigns it to @mission for use by the controller action.
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
