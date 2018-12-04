class MissionsController < ApplicationController
  before_action :authenticate_member!
  def index
  end

  def show
  end

  def edit
    # décommenter le reste de la ligne suivante quand les admins seront crées
    redirect_to missions_path # unless admin_signed_in?
  end
end
