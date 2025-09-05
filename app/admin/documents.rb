# frozen_string_literal: true

ActiveAdmin.register Document do
  menu if: proc { authorized? :index, Document }
  permit_params :published, :file, :category, :name, :date
  actions :all, except: [:show]
  includes file_attachment: :blob

  filter :created_at
  filter :updated_at
  filter :published
  filter :category

  index do
    selectable_column
    column :name
    column :date
    column(:preview) do |document|
      if document.file.previewable?
        link_to(image_tag(document.file.preview(resize_to_limit: [90, 90])),
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
      f.input :name
      f.input :date, start_year: 2018, end_year: Date.current.year + 2
      f.input :published
      f.input :file, as: :file if f.object.new_record?
    end
    f.actions
  end
end
