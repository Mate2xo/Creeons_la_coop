module Documents
  class UpdateTransaction
    include Dry::Transaction

    step :change_filename
    step :update_file

    def change_filename(params)
      blob = get_blob(params[:document])
      new_filename = "#{params[:file_name]}#{blob.filename.extension_with_delimiter}"

      if params[:file_name].blank?
        Success(params)
      elsif blob.update(filename: new_filename)
        Success(params)
      else
        error_message(params[:document])
      end
    end

    def update_file(params)
      if params[:document].update(category: params[:category])
        Success(params)
      else
        error_message(params[:document])
      end
    end

    private
    def get_blob(id)
      ActiveStorage::Blob.find(ActiveStorage::Attachment.find_by(record_id: id).blob_id)
    end

    def error_message(document)
      failure_message = <<-MESSAGE
        "#{I18n.t('activerecord.errors.messages.update_fail')}
        #{document.errors.full_messages.join(', ')}"
      MESSAGE
      Failure(failure_message)
    end
  end
end
