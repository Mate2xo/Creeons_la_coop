class Address < ApplicationRecord
    belongs_to :member, optional: true
    belongs_to :productor, optional: true
    belongs_to :mission, optional: true
end
