# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :productor, optional: true
  belongs_to :member, optional: true
  has_and_belongs_to_many :missions

  # before_save :assign_coordonnee, on: [:create, :update]

  validates :city, :postal_code, presence: true

  def assign_coordonnee
    require "addressable/uri"
    url = ""
    coordonnee = ""
    if postal_code
      url = postal_code + " "
    end
    if city
      url = url + city + " "
    end
    if street_name_1
      url = url + street_name_1 + " "
    end
    if street_name_2
      url += street_name_2
    end
    if (address = Addressable::URI.parse(url).normalize.to_str) != (nil || "")
      response = RestClient.get ("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "+france&key=" + Rails.application.credentials[:google_key] ), accept: :json
      response = JSON.parse(response.body)
      if response["status"] == "OK" && response["results"][0]
        lat = response["results"][0]["geometry"]["location"]["lat"]
        lng = response["results"][0]["geometry"]["location"]["lng"]
        coordonnee = "{lat: " + lat.to_s + " , lng: " + lng.to_s + "}"
      end
    end
    self.coordonnee = coordonnee
  end
end
