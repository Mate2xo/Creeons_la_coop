# frozen_string_literal: true

module Documents
# == Schema Information
#
# Table name: documents_sub_categories
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_documents_sub_categories_on_category_id           (category_id)
#  index_documents_sub_categories_on_name_and_category_id  (name,category_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => documents_categories.id)
#
  # Further classify documents within a given Category
  class SubCategory < ApplicationRecord
    belongs_to :category, class_name: 'Documents::Category'
    has_many :documents, dependent: :nullify

    validates :name, presence: true, uniqueness: {scope: :category_id}

    def self.ransackable_attributes(auth_object = nil)
      return [] unless auth_object

      case auth_object.user.role.to_sym
      when :super_admin, :admin
        authorizable_ransackable_attributes + _ransackers.keys
      else
        []
      end
    end

    def self.ransackable_associations(auth_object = nil)
      return [] unless auth_object

      case auth_object.user&.role&.to_sym
      when :super_admin, :admin
        %i[category documents]
      else
        []
      end
    end
  end
end
