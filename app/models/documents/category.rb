# frozen_string_literal: true

module Documents
  class Category < ApplicationRecord # rubocop:disable Style/Documentation
    has_many :documents, dependent: :nullify

    validates :name, presence: true

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

      case auth_object.user.role.to_sym
      when :super_admin, :admin
        [:documents]
      else
        []
      end
    end
  end
end
