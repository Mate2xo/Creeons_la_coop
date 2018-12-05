class MissionsController < ApplicationController
  before_action :authenticate_member!
  def index
    @missions = Mission.all
  end

  def show
    @missions = Mission.find(params[:id])
  end

  def edit
    # décommenter le reste de la ligne suivante quand les admins seront crées
    redirect_to missions_path # unless admin_signed_in?
  end
end
