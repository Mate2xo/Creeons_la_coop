# frozen_string_literal: true

# == Schema Information
#
# Table name: infos
#
#  id         :bigint           not null, primary key
#  category   :string
#  content    :text
#  published  :boolean          default(FALSE)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint
#
# Indexes
#
#  index_infos_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => members.id)
#

class Info < ApplicationRecord
  extend Enumerize

  belongs_to :author, class_name: 'Member' # , foreign_key: "author_id"

  enumerize :category, in: %i[news event management], default: :news
  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    return [] unless auth_object

    case auth_object.user.role.to_sym
    when :super_admin, :admin
      column_names + _ransackers.keys
    else
      []
    end
  end

  def self.ransackable_associations(_auth_object = nil) = []
end
