# frozen_string_literal: true

# Document management
class DocumentsController < ApplicationController
  def index
    scope = policy_scope(Document)
    @documents_by_category = authorize(scope).order(date: :desc)
                                             .includes(:category)
                                             .with_attached_file
                                             .group_by(&:category)
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
