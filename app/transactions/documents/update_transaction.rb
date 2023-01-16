module Documents
  class UpdateTransaction
    include Dry::Transaction

    step :change_filename
    step :update_file

    def change_filename(params, document:)
      if params[:file_name].present?
        blob_id = ActiveStorage::Attachment.find_by(record_id: document.id).blob_id
        blob = ActiveStorage::Blob.find(blob_id)
        extension = blob.filename.extension_with_delimiter
        if blob.update(filename: "#{params[:file_name]}#{extension}")
          Success(params)
        else
          failure_message = <<-MESSAGE
            "#{I18n.t('activerecord.errors.messages.update_fail')}
            #{document.errors.full_messages.join(', ')}"
          MESSAGE
          Failure(failure_message)
        end
      else
        Success(params)
      end

    end
    
    def update_file(params, document:)
      if document.update(category: params[:category])
        Success(params)
      else
        failure_message = <<-MESSAGE
          "#{I18n.t('activerecord.errors.messages.update_fail')}
          #{document.errors.full_messages.join(', ')}"
        MESSAGE
        Failure(failure_message)
      end
    end
  end
end
