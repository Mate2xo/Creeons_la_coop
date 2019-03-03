# frozen_string_literal: true

ActiveAdmin.register Productor do
  permit_params :name, :description, :phone_number, :website_url
end
