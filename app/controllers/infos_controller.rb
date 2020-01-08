# frozen_string_literal: true

# Newsfeeds, creatable by admins
class InfosController < ApplicationController
  before_action :authenticate_member!

  def index
    @infos = Info.all
    @document = Document.new
    @documents = Document.with_attached_file
  end

  def new
    if current_member.role == "super_admin" || current_member.role == "admin"
      @info = Info.new
    else
      flash[:error] = "Veuillez contacter votre administrateur"
      redirect_to "/infos"
    end
  end

  def create
    if current_member.role == "super_admin" || current_member.role == "admin"
      @info = Info.new(permitted_params)
      @info.author = current_member
      if @info.save
        flash[:notice] = "L'info a été créée"
        redirect_to @info
      else
        flash[:error] = "La création de l'info a échoué"
        redirect_to new_info_path
      end
    else
      flash[:error] = "Une erreur est survenue. Veuillez réessayer ou contacter votre administrateur"
      redirect_to "/infos"
    end
  end

  def show
    @info = Info.find(params[:id])
  end

  def edit
    if current_member.role == "super_admin" || current_member.role == "admin"
      @info = Info.find(params[:id])
    else
      redirect_to "/infos"
    end
  end

  def update
    if current_member.role == "super_admin" || current_member.role == "admin"
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
    if current_member.role == "super_admin" || current_member.role == "admin"
      Info.find(params[:id]).destroy
    end
    flash[:notice] = "La mission a été supprimée"
    redirect_to "/infos"
  end

  private

  def permitted_params
    params.require(:info).permit(:title, :content)
  end
end
