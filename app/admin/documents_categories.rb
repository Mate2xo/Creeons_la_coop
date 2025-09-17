# frozen_string_literal: true

ActiveAdmin.register Documents::Category do
  menu if: proc { authorized? :index, Documents::Category }, parent: :documents
  permit_params :name, sub_categories_attributes: %i[name id _destroy]

  filter :name
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name
    end
    f.inputs resource.sub_categories.model_name.human.pluralize do
      f.has_many :sub_categories, allow_destroy: true, new_record: true, heading: false do |scf|
        scf.input :name
      end
    end
    f.actions
  end

  show do
    panel t 'active_admin.details', model: resource.model_name.human do
      attributes_table_for resource do
        row :name
        row :created_at
        row :updated_at
        row :documents
      end
    end

    panel resource.sub_categories.model_name.human.pluralize do
      table_for resource.sub_categories do
        column(&:name)
        column(&:documents)
      end
    end
  end
end
