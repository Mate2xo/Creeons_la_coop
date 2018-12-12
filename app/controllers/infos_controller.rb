# Newsfeeds, creatable by admins
class InfosController < ApplicationController
  before_action :authenticate_member!

  def index
    @infos = Info.all
  end

  def new
    @info = Info.new
  end

  def create
    @info = Info.new(permitted_params)
    @info.author = current_member
    if @info.save
      flash[:notice] = "L'info a été créée"
      redirect_to @info
    else
      flash[:error] = "La création de l'info a échoué"
      redirect_to new_info_path
    end
  end

  def show
    @info = Info.find(params[:id])
  end

  def edit
    if current_member.role == "super_admin" || current_member.role == "admin" || current_member.id == Info.find(params[:id]).author_id
      @info = Info.find(params[:id])
    else
      redirect_to "/infos"
    end
  end

  def update
    if current_member.role == "super_admin" || current_member.role == "admin" || current_member.id == Info.find(params[:id]).author_id
      @info = Info.find(params[:id])
      if @info.update_attributes(permitted_params)
        flash[:notice] = "L'info a été mise à jour"
        redirect_to @info
      else
        flash[:error] = "Une erreur est survenue. Veuillez réessayer ou contacter votre administrateur"
        redirect_to edit_info_path(@info.id)
      end
    else
      redirect_to "/infos"
    end
  end

  def destroy
    if current_member.role == "super_admin" || current_member.role == "admin" || current_member.id == Info.find(params[:id]).author_id
      Info.find(params[:id]).destroy
    end
      flash[:notice] = "La mission a été suprimer"
      redirect_to "/infos"
  end

  private

  def permitted_params
    params.require(:info).permit(:title, :content)
  end
end
