class Productor < ApplicationRecord
    has_one :address, dependent: :nullify
    has_and_belongs_to_many :missions
  	has_one_attached :avatar
    validates :name, presence: true, uniqueness: true
end
