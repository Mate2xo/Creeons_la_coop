# frozen_string_literal: true

class LibrariesController < ApplicationController
  def index; end

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
      @libraries = Library.with_attached_document
      respond_to do |format|
        format.js
        if @library.save
          format.html { redirect_to @library, notice: "Le document a été ajouté" }
        else
          format.html { redirect_to new_library_path, error: "Le téléchargement du document a échoué" }
        end
      end
    else
      redirect_to "/infos#documents", error: "Une erreur est survenue. Veuillez réessayer ou contacter votre administrateur"
    end
  end

  def show; end

  def destroy
    if current_member.role == "super_admin" || current_member.role == "admin"
      @library = Library.find(params[:id])
      @library.destroy
    end
    respond_to do |format|
      format.js
      format.html { redirect_to "/infos#documents", notice: "Le document a été supprimé" }
    end
  end

  private

  def permitted_params
    params.require(:library).permit(:document)
  end
end
