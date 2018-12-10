class Mission < ApplicationRecord
    belongs_to :author, class_name: "Member" #, foreign_key: "author_id"
    has_and_belongs_to_many :members
    has_and_belongs_to_many :productors
    has_and_belongs_to_many :addresses
end
