# frozen_string_literal: true

# == Schema Information
#
# Table name: libraries
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Library < ApplicationRecord
  has_many_attached :documents
end
