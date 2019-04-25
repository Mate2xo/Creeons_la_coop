# frozen_string_literal: true

ActiveAdmin.register Mission do
  permit_params :author_id, :name, :description, :max_member_count, :min_member_count, :due_date

  index do
    selectable_column
    column :name
    column :description
    column :recurrent
    column :due_date
    column :author
    actions
  end

  form do |f|
    f.inputs do
      f.input :author,
              collection: options_from_collection_for_select(Member.all, :id, :email)
      f.input :name
      f.input :description
      f.input :max_member_count
      f.input :min_member_count
      f.input :recurrent
      f.input :due_date
    end

    actions
  end
end
