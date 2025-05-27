# frozen_string_literal: true

ActiveAdmin.register Productor do
  permit_params :name,
                :description,
                :category,
                :local,
                :phone_number,
                :website_url,
                :avatar,
                catalogs: [],
                address_attributes: [
                  :_destroy,
                  :city,
                  :id,
                  :postal_code,
                  :street_name_1,
                  :street_name_2,
                  {coordinates: []}
                ]

  menu if: proc { authorized? :index, %i[active_admin Productor] } # display menu according to ActiveAdmin::Policy

  index do
    selectable_column
    column :name
    column :description
    column(:category, &:category_text)
    column :local
    column :phone_number
    column :website_url do |productor|
      link_to productor.website_url, productor.website_url
    end
    actions
  end

  filter :name
  filter :description
  filter :phone_number
  filter :website_url
  filter :local
  filter :category, as: :select, collection: Productor.category.options

  form do |f|
    f.inputs :name, :description, :local, :phone_number, :website_url
    f.inputs do
      f.input :category, as: :select, collection: Productor.category.options
    end
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
