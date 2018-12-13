# frozen_string_literal: true

# The websites users. Their 'role' attributes determines if fhey're an unvalidated user, a member, admin or super-admmin
class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  has_and_belongs_to_many :missions
  has_and_belongs_to_many :managed_productors, class_name: "Productor"
  has_one_attached :avatar
end
