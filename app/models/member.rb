class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :address, dependent: :destroy
  has_and_belongs_to_many :missions
  has_and_belongs_to_many :managed_productors, class_name: "Productor"
  has_one_attached :avatar
end
