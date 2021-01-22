# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint(8)        not null, primary key
#  published  :boolean          default: false
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Document < ApplicationRecord
  has_one_attached :file
  validates :file, attached: true, size: { less_than: 20.megabytes }, content_type: [
    'application/pdf',
    'application/msword', # .doc
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document', # .docx
    'application/vnd.oasis.opendocument.text', # .odt
    'application/vnd.ms-excel', # .xls
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', # .xlsx
    'text/plain'
  ]
end
