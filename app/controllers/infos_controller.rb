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
      flash[:success] = "Info successfully created"
      redirect_to @info
    else
      flash[:error] = "Something went wrong"
      redirect_to new_info_path
    end
  end


  def show
    @info = Info.find(params[:id])
  end

  def edit
    @info = Info.find(params[:id])
  end

  def update
    @info = Info.find(params[:id])
      if @info.update_attributes(permitted_params)
        flash[:notice] = "L'info a été mise à jour"
        redirect_to @info
      else
        flash[:error] = "Une erreur est survenue. Veuillez réessayer ou contacter votre administrateur"
        redirect_to edit_info_path(@info.id)
      end
  end

  private

  def permitted_params
    params.require(:info).permit(:title, :content)
  end
end
