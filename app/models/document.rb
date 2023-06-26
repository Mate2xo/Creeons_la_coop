# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint(8)        not null, primary key
#  category   :string           default: weekly_orders
#  published  :boolean          default: false
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Document < ApplicationRecord
  extend Enumerize
  extend ActiveModel::Naming

  has_one_attached :file
  has_one :file_attachment, class_name: 'ActiveStorage::Attachment', as: :record, dependent: :destroy
  has_one :file_blob, through: :file_attachment, source: :blob

  enumerize :category, in: %i[weekly_orders
                              newsletters
                              official_documents
                              financial_documents
                              communications
                              reports
                              procedures
                              questionnaires
                              recipes],
                       default: :weekly_orders

  validates :file, attached: true, size: { less_than: 20.megabytes }, content_type: [
    'application/pdf',
    'application/msword', # .doc
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document', # .docx
    'application/vnd.oasis.opendocument.text', # .odt
    'application/vnd.ms-excel', # .xls
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', # .xlsx
    'text/plain'
  ]

  scope :joined_with_name, -> { joins(:file_blob) }
end
