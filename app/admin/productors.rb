# frozen_string_literal: true

ActiveAdmin.register Productor do
  permit_params :name, :description, :local,
                :phone_number, :website_url, :avatar,
                catalogs: [],
                address_attributes: [:id, :postal_code, :city,
                                     :street_name_1, :street_name_2,
                                     coordinates: []]

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

  form do |f|
    f.inputs :name, :description, :local, :phone_number, :website_url
    f.inputs do
      f.has_many :address, allow_destroy: true do |address|
        address.input :street_name_1
        address.input :street_name_2
        address.input :postal_code
        address.input :city
        address.input :coordinates, as: :coordinates
      end
    end
    actions
  end
end
