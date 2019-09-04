# frozen_string_literal: true

class AttachedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :attached, options) unless value.attached?
  end
end
