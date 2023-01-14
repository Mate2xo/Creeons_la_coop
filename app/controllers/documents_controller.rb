# frozen_string_literal: true

# Document management
class DocumentsController < ApplicationController
  def index
    @document = Document.new
    @documents = if member_signed_in?
                   Document.with_attached_file
                 else
                   Document.where(published: true).with_attached_file
                 end
  end

  def edit
    @document = authorize Document.find(params[:id])
  end

  def create
    @document = authorize Document.new(permitted_params)
    @document.save

    flash.merge! user_feedback_on_create(@document)
    respond_to do |format|
      format.js
      format.html { redirect_to documents_path(anchor: 'documents') }
    end
  end

  def update
    @document = authorize Document.find(params[:id])
    if update_transaction.success?
      flash[:notice] = t 'activerecord.notices.messages.update_success'
      redirect_to documents_path
    else
      flash[:error] = transaction[:errors]
      render :edit
    end
  end

  def destroy
    @document = authorize Document.find(params[:id])
    @document.destroy
    flash[:notice] = t('activerecord.notices.messages.record_destroyed',
                       model: @document.model_name.singular)

    respond_to do |format|
      format.js
      format.html { redirect_to documents_path(anchor: 'documents') }
    end
  end

  private

  def permitted_params
    params.require(:document).permit(:category, :file, :file_name)
  end

  def update_transaction
    @update_transaction ||=
      begin
        Documents::UpdateTransaction.new.with_step_args(
          change_filename: [document: @document],
          update_file: [document: @document]
        ).call(permitted_params)
      end
  end

  def user_feedback_on_create(record)
    if record.persisted?
      message = t("activerecord.notices.messages.record_created",
                  model: @document.model_name.singular)
      { notice: message }
    elsif record.invalid?
      message = record.errors.full_messages.join(', ')
      record.file.purge
      { alert: message }
    else
      message = t('activerecord.errors.messages.creation_fail',
                  model: @document.model_name.singular)
      { error: message }
    end
  end
end
