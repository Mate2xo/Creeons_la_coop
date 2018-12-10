class Productor < ApplicationRecord
    has_one :address, dependent: :destroy
    has_and_belongs_to_many :missions
    has_and_belongs_to_many :managers, class_name: "Member"
  	has_one_attached :avatar
    validates :name, presence: true, uniqueness: true
end
