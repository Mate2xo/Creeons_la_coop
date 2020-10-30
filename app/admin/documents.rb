ActiveAdmin.register Document do
  permit_params :file

  includes(file_attachment: :blob)

  index do
    column(:filename) { |document| link_to document.file.filename.to_s, rails_blob_path(document.file, disposition: 'attachment') }
    column(:preview) { |document| link_to(image_tag(document.file.preview(resize: '90x90')), rails_blob_path(document.file, disposition: 'attachment')) }
    column(:exposed)
    actions defaults: false do |document|
      link_to I18n.t('active_admin.delete'),
              admin_document_path(document),
              method: :delete,
              data: { confirm: I18n.t('active_admin.delete_confirmation') },
              class: 'delete_link'
    end
  end

  form do |f|
    f.inputs 'File' do
      f.input :file, as: :file
      f.input :exposed, as: :radio
    end
    f.actions
  end
end
