# frozen_string_literal: true

class LibrariesController < ApplicationController
  def index
    @libraries = Library.all
  end

  def new
    if current_member.role == "super_admin" || current_member.role == "admin"
      @library = Library.new(permitted_params)
    else
      flash[:error] = "Veuillez contacter votre administrateur"
      redirect_to "/infos"
    end
  end

  def create
    if current_member.role == "super_admin" || current_member.role == "admin"
      @library = Library.new
      @library.document.attach(params[:library][:document])
      if @library.save
        flash[:notice] = "Le document a été ajouté"
        redirect_to @library
      else
        flash[:error] = "Le téléchargement du document a échoué"
        redirect_to new_library_path
      end
    else
      flash[:error] = "Une erreur est survenue. Veuillez réessayer ou contacter votre administrateur"
      redirect_to "/infos"
    end
  end

  def show; end

  def destroy
    if current_member.role == "super_admin" || current_member.role == "admin"
      Library.find(params[:id]).destroy
    end
    flash[:notice] = "Le document a été supprimé"
    redirect_to "/infos"
  end

  private

  def permitted_params
    params.require(:library).permit(:document)
  end
end
