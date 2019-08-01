# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  biography              :text
#  phone_number           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string           default("member")
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#

# The websites users. Their 'role' attributes determines if fhey're an unvalidated user, a member, admin or super-admmin
class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  has_many :created_missions, class_name: 'Mission', inverse_of: 'author', foreign_key: 'author_id', dependent: :nullify
  has_many :created_infos, class_name: 'Info', inverse_of: 'author', foreign_key: 'author_id', dependent: :nullify
  has_and_belongs_to_many :missions, dependent: :nullify
  has_and_belongs_to_many :managed_productors, class_name: "Productor"
  has_one_attached :avatar

  validates :first_name, presence: true
  validates :last_name, presence: true

  enum group: { aucun: 0, collectif: 1, gestion: 2, communication: 3, maintenance_approvisionnement: 4, vie_associative: 5, informatique: 6 }
end
