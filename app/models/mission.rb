class Mission < ApplicationRecord
    has_and_belongs_to_many :members
    has_and_belongs_to_many :productors
    has_and_belongs_to_many :addresses
end
