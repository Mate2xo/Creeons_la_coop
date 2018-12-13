# frozen_string_literal: true

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods: #addresses, #author, #due_date, #name, #description
class MissionsController < ApplicationController
  before_action :authenticate_member!

  def index
    @missions = Mission.all
  end

  def new
    @mission = Mission.new

    # address form generator
    2.times { @mission.addresses.build }
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

  def show
    @mission = Mission.find(params[:id])
  end

  def edit
    if current_member.role == "super_admin" || current_member.role == "admin" || current_member.id == Mission.find(params[:id]).author_id
      @mission = Mission.find(params[:id])
      # address form generator
      1.times { @mission.addresses.build }
      @mission_addresses = @mission.addresses || @mission.addresses.build
    else
      redirect_to mission_path
    end
  end

  def update
    if current_member.role == "super_admin" || current_member.role == "admin" || current_member.id == Mission.find(params[:id]).author_id
      @mission = Mission.find(params[:id])
      if @mission.update_attributes(permitted_params)
        flash[:notice] = "La mission a été mise à jour"
        redirect_to @mission
      else
        flash[:error] = "La mise à jour de la misison a échoué"
        redirect_to edit_mission_path(@mission.id)
      end
    else
      redirect_to mission_path
    end
  end

  def destroy
    if current_member.role == "super_admin" || current_member.role == "admin" || current_member.id == Mission.find(params[:id]).author_id
      Mission.find(params[:id]).destroy
    end
    flash[:notice] = "La mission a été supprimée"
    redirect_to "/missions"
  end

  private

  def permitted_params
    params.require(:mission).permit(:name, :description, :due_date, addresses_attributes: [:id, :postal_code, :city, :street_name_1, :street_name_2])
  end
end
