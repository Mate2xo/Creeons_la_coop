# frozen_string_literal: true

class DocumentsController < ApplicationController
  def create
    @document = authorize Document.new(permitted_params)
    @document.save
    respond_to do |format|
      format.js
      format.html {
        redirect_to infos_path(anchor: 'documents'), user_feedback_on_create(@document)
      }
    end
  end

  def destroy
    @document = authorize Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.js
      format.html {
        redirect_to infos_path(anchor: 'documents'),
                    notice: t('activerecord.notices.messages.record_destroyed',
                              model: @document.model_name.singular)
      }
    end
  end

  private

  def permitted_params
    params.require(:document).permit(:file)
  end

  def user_feedback_on_create(record)
    if record.persisted?
      message = t("activerecord.notices.messages.record_created",
                  model: @document.model_name.singular)
      { notice: message }
    else
      message = t('activerecord.errors.messages.creation_fail',
                  model: @document.model_name.singular)
      { error: message }
    end
  end
end
