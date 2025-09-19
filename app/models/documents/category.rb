# frozen_string_literal: true

# == Schema Information
#
# Table name: documents_categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_documents_categories_on_name  (name) UNIQUE
#
module Documents
  class Category < ApplicationRecord # rubocop:disable Style/Documentation
    has_many :documents, dependent: :restrict_with_error
    has_many :sub_categories, dependent: :destroy
    accepts_nested_attributes_for :sub_categories, reject_if: :all_blank, allow_destroy: true

    validates :name, presence: true, uniqueness: true

    def self.ransackable_attributes(auth_object = nil)
      return [] unless auth_object

      case auth_object.user.role.to_sym
      when :super_admin, :admin
        column_names + _ransackers.keys
      else
        []
      end
    end

    def self.ransackable_associations(auth_object = nil)
      return [] unless auth_object

      case auth_object.user&.role&.to_sym
      when :super_admin, :admin
        %i[documents sub_categories]
      else
        []
      end
    end
  end
end
