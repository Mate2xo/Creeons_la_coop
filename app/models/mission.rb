class Mission < ApplicationRecord
    has_many :members
    has_many :productors
    has_many :adresses
    has_many :infos
end
