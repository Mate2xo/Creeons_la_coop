class Address < ApplicationRecord
    belongs_to :productor, optional: true
    belongs_to :member, optional: true
    has_and_belongs_to_many :missions
end
