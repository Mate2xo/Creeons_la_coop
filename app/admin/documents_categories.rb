# frozen_string_literal: true

ActiveAdmin.register Documents::Category do
  menu if: proc { authorized? :index, Documents::Category }, parent: :documents
  permit_params :name

  show do
    panel t 'active_admin.details', model: resource.model_name.human do
      attributes_table_for resource do
        row :name
        row :created_at
        row :updated_at
        row :documents
      end
    end
  end
end
