# frozen_string_literal: true

class DocumentsController < ApplicationController
  def create
    @document = authorize Document.new(permitted_params)

    respond_to do |format|
      if @document.save
        format.js
        format.html {
          redirect_to infos_path(anchor: 'documents'),
                      notice: "Le document a été ajouté"
        }
      else
        format.html {
          redirect_to infos_path(anchor: 'documents'),
                      error: "Le téléchargement du document a échoué"
        }
      end
    end
  end

  def destroy
    @document = authorize Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.js
      format.html {
        redirect_to infos_path(anchor: 'documents'),
                    notice: "Le document a été supprimé"
      }
    end
  end

  private

  def permitted_params
    params.require(:document).permit(:file)
  end
end
