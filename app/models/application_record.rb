# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.human_enum_name(enum_name, enum_value)
    return if enum_name.nil? || enum_value.nil?

    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def self.human_model_name(value)
    return if value.nil?

    I18n.t("activerecord.models.#{model_name.i18n_key}.attributes.name.#{value}")
  end
end
