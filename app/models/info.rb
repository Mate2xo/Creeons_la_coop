# frozen_string_literal: true

class Info < ApplicationRecord
  validates :title, presence: true
  belongs_to :author, class_name: "Member" # , foreign_key: "author_id"
end
