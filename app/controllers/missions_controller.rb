# frozen_string_literal: true

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods: #addresses, #author, #due_date, #name, #description, #members
class MissionsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_mission, only: %i[show edit update destroy enroll disenroll]

  def index
    @missions = Mission.all
  end

  def new
    @mission = Mission.new

    # address form generator
  end

  def create
    @mission = Mission.new(permitted_params)
    @mission.author = current_member

    if @mission.save
      flash[:notice] = "La mission a été créée"
      redirect_to @mission
    else
      flash[:error] = "La création de mission a échoué"
      redirect_to new_mission_path
    end
  end

  def show; end

  def edit
    redirect_to mission_path unless super_admin? || admin? || current_member.id == @mission.author_id
  end

  def update
    redirect_to mission_path unless super_admin? || admin? || current_member.id == @mission.author_id

    if @mission.update_attributes(permitted_params)
      flash[:notice] = "La mission a été mise à jour"
      redirect_to @mission
    else
      flash[:error] = "La mise à jour de la misison a échoué"
      redirect_to edit_mission_path(@mission.id)
    end
  end

  def destroy
    if super_admin? || admin? || current_member.id == @mission.author_id
      @mission.destroy
      flash[:notice] = "La mission a été supprimée"
    end
    redirect_to "/missions"
  end

  def enroll
    if @mission.members.count >= @mission.max_member_count || @mission.members.where(id: current_member.id).present?
      flash[:alert] = "Le nombre maximum de participants est déjà atteint"
    else
      @mission.members << current_member
      flash[:notice] = "Vous vous êtes inscrit à cette mission"
    end

    redirect_to mission_path(params[:id])
  end

  def disenroll
    @mission.members.destroy(current_member.id)
    flash[:alert] = "Vous ne participez plus à cette mission"
    redirect_to mission_path(params[:id])
  end

  private

  def permitted_params
    params.require(:mission).permit(:name, :description, :recurrent,
                                    :max_member_count, :min_member_count,
                                    :due_date, :start_date,
                                    addresses_attributes: %i[id postal_code city street_name_1 street_name_2 _destroy])
  end

  def set_mission
    @mission = Mission.find(params[:id])
  end
end
