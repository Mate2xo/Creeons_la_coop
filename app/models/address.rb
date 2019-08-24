# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id            :bigint(8)        not null, primary key
#  postal_code   :string
#  city          :string           not null
#  street_name_1 :string
#  street_name_2 :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  productor_id  :bigint(8)
#  member_id     :bigint(8)
#  coordinates   :float            is an Array
#

class Address < ApplicationRecord
  belongs_to :productor, optional: true
  belongs_to :member, optional: true
  has_and_belongs_to_many :missions

  before_save :nullify_coordinates, if: :invalid_coordinates?
  before_save :fetch_coordinates, if: :no_productor_coordinates?
  before_update :fetch_coordinates, if: :address_changed_with_no_new_coordinates?

  validates :city, :postal_code, presence: true

  def fetch_coordinates
    puts '#fetch_coordinates has been launched'
    # require "addressable/uri"
    # url = ""
    # coordinates = ""
    # if postal_code
    #   url = postal_code + " "
    # end
    # if city
    #   url = url + city + " "
    # end
    # if street_name_1
    #   url = url + street_name_1 + " "
    # end
    # if street_name_2
    #   url += street_name_2
    # end
    # if (address = Addressable::URI.parse(url).normalize.to_str) != (nil || "")
    #   response = RestClient.get ("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "+france&key=" + Rails.application.credentials[:google_key] ), accept: :json
    #   response = JSON.parse(response.body)
    #   if response["status"] == "OK" && response["results"][0]
    #     lat = response["results"][0]["geometry"]["location"]["lat"]
    #     lng = response["results"][0]["geometry"]["location"]["lng"]
    #     coordinates = "{lat: " + lat.to_s + " , lng: " + lng.to_s + "}"
    #   end
    # end
    # self.coordinates = coordinates
  end

  private

  def no_productor_coordinates?
    !productor.nil? && coordinates.nil? ? true : false
  end

  def address_changed_with_no_new_coordinates?
    changed? && !coordinates_changed?
  end

  def nullify_coordinates
    self.coordinates = nil
  end

  def invalid_coordinates?
    coordinates == [nil, nil] || !coordinates.nil? && !coordinates[0] || !coordinates.nil? && !coordinates[1]
  end
end
