class Address < ApplicationRecord
    belongs_to :member
    belongs_to :productor
    belongs_to :mission
end
