# frozen_string_literal: true

# Document management
class DocumentsController < ApplicationController
  include Pagy::Backend

  def index
    scope = policy_scope(Document)
    @q = scope.ransack params[:q], auth_object: policy(Document)
    @q.sorts = 'date desc' if @q.sorts.empty?
    @pagy, @documents = pagy @q.result.includes(file_attachment: :blob)
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
