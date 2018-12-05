class Productor < ApplicationRecord
    has_one :address, dependent: :nullify
    has_and_belongs_to_many :missions

    validates :name, presence: true, uniqueness: true
end
