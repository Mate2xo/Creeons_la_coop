# frozen_string_literal: true

ActiveAdmin.register Info do # rubocop:disable Metrics/BlockLength
  permit_params :title, :content, :category, :author_id, :published

  menu if: proc { authorized? :index, %i[active_admin Info] } # display menu according to ActiveAdmin::Policy

  index do
    selectable_column
    column :title
    column :category
    column :content
    column :published
    column :author
    actions
  end

  form do |f|
    f.inputs do
      preset_author_id = f.object.persisted? ? f.object.author_id : current_member.id

      f.input :author,
              as: :select,
              collection: Member.pluck(:email, :id),
              selected: Member.find(preset_author_id).attributes.fetch_values('email', 'id')
      f.input :title
      f.input :category
      f.input :content
      f.input :published
    end
    actions
  end
end
