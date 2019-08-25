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
  before_save :assign_coordinates, if: :no_productor_coordinates?
  before_update :assign_coordinates, if: :address_changed_with_no_new_coordinates?

  validates :city, :postal_code, presence: true

  def assign_coordinates
    response = fetch_coordinates
    return if response.nil? || response.code != 200

    data = JSON.parse response.body, symbolize_names: true
    new_coordinates = data.dig(:features, 0, :geometry, :coordinates)
    return unless new_coordinates

    self.coordinates = new_coordinates.reverse
    save
  end

  def fetch_coordinates
    template = Addressable::Template.new("https://api-adresse.data.gouv.fr/search/{?query*}")
    uri = template.expand(
      query: {
        q: "#{street_name_1} #{street_name_2}",
        postcode: postal_code,
        limit: 3
      }
    )
    HTTParty.get uri
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
