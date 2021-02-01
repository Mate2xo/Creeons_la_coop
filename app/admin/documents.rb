# frozen_string_literal: true

ActiveAdmin.register Document do
  permit_params :published, :file, :category
  actions :all, except: [:show]

  menu if: proc { authorized? :index, %i[active_admin Document] } # display menu according to ActiveAdmin::Policy

  index do
    selectable_column
    column(:filename) do |document|
      link_to(document.file.filename,
              rails_blob_path(document.file, disposition: 'attachment'))
    end
    column(:preview) do |document|
      if document.file.previewable?
        link_to(image_tag(document.file.preview(resize: '90x90')),
                rails_blob_path(document.file, disposition: 'attachment'))
      end
    end
    column :category
    column :published
    actions do |document|
      link_to t('main_app.views.application.buttons.edit'), edit_admin_document_path(document)
    end
  end

  form do |f|
    f.inputs do
      f.input :category
      f.input :published
      f.input :file, as: :file if f.object.new_record?
    end
    f.actions
  end
end
