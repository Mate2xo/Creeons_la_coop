class MissionsController < ApplicationController
  before_action :authenticate_member!

  def index
    @missions = Mission.all
  end

  def new
    @mission = Mission.new
    2.times {@mission.addresses.build}
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
    @mission = Mission.find(params[:id])
    # @mission_addresses = @mission.addresses
  end

  def update
    @mission = Mission.find(params[:id])
      if @mission.update_attributes(permitted_params)
        flash[:notice] = "La mission a été mise à jour"
        redirect_to @mission
      else
        flash[:error] = "La mise à jour de la misison a échoué"
        redirect_to edit_mission_path(@mission.id)
      end
  end
  

  private

  def permitted_params
    params.require(:mission).permit(:name, :description,:due_date, addresses_attributes: [:id, :postal_code, :city, :street_name_1, :street_name_2])
  end
end
