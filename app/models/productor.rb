class Productor < ApplicationRecord
    has_many :missions
    belongs_to :adress
end
