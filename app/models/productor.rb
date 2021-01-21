# frozen_string_literal: true

# == Schema Information
#
# Table name: productors
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  description  :text
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  website_url  :string
#  local        :boolean          default(FALSE)
#

# Ressource for the members to get products from (vegetables...), and are managed by the 'management/supply' team
class Productor < ApplicationRecord
  extend Enumerize

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true, update_only: true
  has_and_belongs_to_many :missions, dependent: :nullify
  has_and_belongs_to_many :managers, class_name: "Member", dependent: :nullify
  has_one_attached :avatar
  has_many_attached :catalogs

  enumerize :category, in: %i[bio_and_ethical bio conventional]

  validates :name, presence: true, uniqueness: true
end
