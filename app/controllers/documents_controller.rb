# frozen_string_literal: true

# Document management
class DocumentsController < ApplicationController
  def index
    @documents = policy_scope(Document).order(date: :desc).with_attached_file
  end

  def destroy
    @document = authorize Document.find(params[:id])
    @document.destroy
    flash[:notice] = t('activerecord.notices.messages.record_destroyed',
                       model: @document.model_name.singular)

    respond_to do |format|
      format.html { redirect_to documents_path(anchor: 'documents') }
    end
  end

  private

  def permitted_params
    params.require(:document).permit(:category, :file)
  end
end
