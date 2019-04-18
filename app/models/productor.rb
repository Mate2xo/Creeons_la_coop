# frozen_string_literal: true

# Ressource for the members to get products from (vegetables...), and are managed by the 'Aprovisionnement/Commande' team
# Can be CRUDed by an admin, R by members
# Available methods: #address, #name, #description, #managers
class Productor < ApplicationRecord
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  has_and_belongs_to_many :missions, dependent: :nullify
  has_and_belongs_to_many :managers, class_name: "Member", dependent: :nullify
  has_one_attached :avatar
  has_many_attached :catalogs

  validates :name, presence: true, uniqueness: true
end
