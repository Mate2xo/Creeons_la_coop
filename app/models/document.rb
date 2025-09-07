# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean          default(FALSE)
#  category   :string           default("weekly_orders")
#

# Various uploaded files, that any member can access
class Document < ApplicationRecord
  extend Enumerize
  extend ActiveModel::Naming

  has_one_attached :file
  belongs_to :category, class_name: 'Documents::Category'

  validates :date, :name, presence: true
  validates :file, attached: true, size: {less_than: 20.megabytes}, content_type: [
    'application/pdf',
    'application/msword', # .doc
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document', # .docx
    'application/vnd.oasis.opendocument.text', # .odt
    'application/vnd.ms-excel', # .xls
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', # .xlsx
    'text/plain'
  ]

  def self.ransackable_attributes(auth_object = nil)
    return [] unless auth_object

    case auth_object.user&.role&.to_sym
    when :super_admin, :admin
      column_names + _ransackers.keys
    else
      %i[name category_id]
    end
  end

  def self.ransackable_associations(_auth_object = nil) = []
end
