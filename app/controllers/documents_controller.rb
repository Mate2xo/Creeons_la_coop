# frozen_string_literal: true

class DocumentsController < ApplicationController
  def index; end

  def new
    if current_member.role == "super_admin" || current_member.role == "admin"
      @document = Document.new
    else
      flash[:error] = "Veuillez contacter votre administrateur"
      redirect_to "/infos"
    end
  end

  def create
    if current_member.role == "super_admin" || current_member.role == "admin"
      @document = Document.new(permitted_params)
      respond_to do |format|
        format.js
        if @document.save
          format.html { redirect_to @document, notice: "Le document a été ajouté" }
        else
          format.html { redirect_to new_document_path, error: "Le téléchargement du document a échoué" }
        end
      end
    else
      redirect_to "/infos#documents", error: "Une erreur est survenue. Veuillez réessayer ou contacter votre administrateur"
    end
  end

  def show; end

  def destroy
    if current_member.role == "super_admin" || current_member.role == "admin"
      @document = Document.find(params[:id])
      @document.destroy
    end
    respond_to do |format|
      format.js
      format.html { redirect_to "/infos#documents", notice: "Le document a été supprimé" }
    end
  end

  private

  def permitted_params
    params.require(:document).permit(:file)
  end
end
