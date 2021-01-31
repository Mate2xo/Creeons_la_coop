# frozen_string_literal: true

# == Schema Information
#
# Table name: infos
#
#  id         :bigint(8)        not null, primary key
#  content    :text
#  category   :string
#  published  :boolean          default, false
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint(8)
#

class Info < ApplicationRecord
  extend Enumerize

  belongs_to :author, class_name: "Member" # , foreign_key: "author_id"

  enumerize :category, in: %i[news event management], default: :news
  validates :title, presence: true
end
