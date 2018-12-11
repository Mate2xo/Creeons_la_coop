class MissionsController < ApplicationController
  before_action :authenticate_member!
  def index
    @missions = Mission.all
  end

  def new
    @mission = Mission.new
  end
  
  def create
    @mission = Mission.new(permitted_params)
    @mission.author = current_member
    if @mission.save
      flash[:success] = "Mission successfully created"
      redirect_to @mission
    else
      flash[:error] = "Something went wrong"
      redirect_to new_mission_path
    end
  end
  

  def show
    @mission = Mission.find(params[:id])
  end

  def edit
    @mission = Mission.find(params[:id])
  end

  def update
    @mission = Mission.find(params[:id])
      if @mission.update_attributes(permitted_params)
        flash[:success] = "Mission was successfully updated"
        redirect_to @mission
      else
        flash[:error] = "Something went wrong"
        redirect_to edit_mission_path(@mission.id)
      end
  end
  

  private

  def permitted_params
    params.require(:mission).permit(:name, :description,:due_date)
  end
end
