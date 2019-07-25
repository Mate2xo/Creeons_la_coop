# frozen_string_literal: true

ActiveAdmin.register Productor do
  permit_params :name, :description, :local, :phone_number, :website_url

  index do
    selectable_column
    column :name
    column :description
    column :local
    column :phone_number
    column :website_url do |productor|
      link_to productor.website_url, productor.website_url
    end
    actions
  end
end
