# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id              :bigint           not null, primary key
#  category        :string           default("weekly_orders")
#  date            :date
#  name            :string
#  published       :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  category_id     :bigint
#  sub_category_id :bigint
#
# Indexes
#
#  index_documents_on_category_id      (category_id)
#  index_documents_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => documents_categories.id)
#  fk_rails_...  (sub_category_id => documents_sub_categories.id)
#

# Various uploaded files, that any member can access
class Document < ApplicationRecord
  extend ActiveModel::Naming

  has_one_attached :file
  belongs_to :category, class_name: 'Documents::Category'
  belongs_to :sub_category, class_name: 'Documents::SubCategory', optional: true

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
  validate :sub_category_belongs_to_associated_category, if: :sub_category

  def self.ransackable_attributes(auth_object = nil)
    return [] unless auth_object

    case auth_object.user&.role&.to_sym
    when :super_admin, :admin
      column_names + _ransackers.keys
    else
      %w[date name category_id sub_category_id]
    end
  end

  def self.ransackable_associations(_auth_object = nil) = []

  private

  def sub_category_belongs_to_associated_category
    return if sub_category.category == category

    errors.add(:sub_category, :not_belonging_to_category)
  end
end
