class Mission < ApplicationRecord
    belongs_to :author, class_name: "Member" #, foreign_key: "author_id"
    has_and_belongs_to_many :members
    has_and_belongs_to_many :productors
    has_and_belongs_to_many :addresses
    accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
end
